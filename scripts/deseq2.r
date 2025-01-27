# Load required libraries
library(DESeq2)
library(tximport)
library(readr)
library(dplyr)  
library(fs)  
library(ggplot2)

# Load metadata
metadata <- read.csv("quant/chinese_spring/metadata.csv")
metadata$condition <- factor(metadata$condition)

# Create named vector of file paths
files <- metadata$path
names(files) <- metadata$sample

# Import Kallisto quantifications
txi <- tximport(files, type = "kallisto", txOut = TRUE)

# Create DESeq2 dataset
dds <- DESeqDataSetFromTximport(txi, colData = metadata, design = ~ condition)

# Pre-filtering to remove  low-count genes
dds <- dds[rowSums(counts(dds) >= 10) >= 2]

# Run DESeq2 analysis
dds <- DESeq(dds)

# Define filtering thresholds
log2fc_threshold <- 2  
high_log2fc_threshold <- 15  
padj_threshold <- 0.05 

# Ensure output directories exist
dir_create("deseq/raw_results")
dir_create("deseq/filtered_results")
dir_create("deseq/high_l2fc_filtered_results")  
dir_create("deseq/plots")  

# PCA Plot for All Samples
vsd <- vst(dds, blind = TRUE)
pca_data <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
percent_var <- round(100 * attr(pca_data, "percentVar"))

p <- ggplot(pca_data, aes(x = PC1, y = PC2, color = condition, label = name)) +
  geom_point(size = 4, shape = 21, fill = "white") +
  geom_text(vjust = -1, size = 3) +
  xlab(paste0("PC1: ", percent_var[1], "% variance")) +
  ylab(paste0("PC2: ", percent_var[2], "% variance")) +
  ggtitle("PCA Plot of Samples") +
  theme_minimal()

ggsave("deseq/plots/PCA_plot.png", plot = p, width = 8, height = 6, dpi = 300)

# Get all condition levels
conditions <- levels(metadata$condition)

# Loop through all pairwise comparisons
for (i in seq_along(conditions)) {
  for (j in seq_along(conditions)) {
    if (i < j) {
      condition_1 <- conditions[i]
      condition_2 <- conditions[j]

      # Prioritize Tween as denominator, otherwise use SN15, otherwise use the lower-indexed condition
      if ("Tween" %in% c(condition_1, condition_2)) {
        numerator <- ifelse(condition_1 == "Tween", condition_2, condition_1)
        denominator <- "Tween"
      } else if ("SN15" %in% c(condition_1, condition_2)) {
        numerator <- ifelse(condition_1 == "SN15", condition_2, condition_1)
        denominator <- "SN15"
      } else {
        # Default to using the lower-indexed condition as the denominator
        numerator <- condition_2
        denominator <- condition_1
      }

      # Ensure numerator ≠ denominator
      if (numerator == denominator) {
        next  # Skip this iteration if invalid comparison
      }

      comparison_name <- paste(numerator, "_vs_", denominator, sep = "")

      # Extract unfiltered results
      res <- as.data.frame(results(dds, contrast = c("condition", numerator, denominator)))[, c("log2FoldChange", "padj")]
      res$gene <- rownames(res)

      # Remove non-coding transcripts (XR-prefixed)
      res <- res %>% filter(!grepl("^XR", gene))

      # Save raw results
      write.csv(res, file = paste0("deseq/raw_results/deseq2_", comparison_name, ".csv"), row.names = FALSE)

      # Apply filtering
      res_filtered <- res %>% filter(abs(log2FoldChange) >= log2fc_threshold & padj <= padj_threshold)
      write.csv(res_filtered, file = paste0("deseq/filtered_results/deseq2_", comparison_name, "_filtered.csv"), row.names = FALSE)

      # Filter for only high |log2FC| genes
      res_high_l2fc <- res_filtered %>% filter(abs(log2FoldChange) >= high_log2fc_threshold)
      write.csv(res_high_l2fc, file = paste0("deseq/high_l2fc_filtered_results/deseq2_", comparison_name, "_high_l2fc.csv"), row.names = FALSE)

      # Volcano Plot
      if (nrow(res_filtered) > 0) {
        p_volcano <- ggplot(res_filtered, aes(x = log2FoldChange, y = -log10(padj))) +
          geom_point(aes(color = case_when(
            log2FoldChange < -15 ~ "Low L2FC",
            log2FoldChange > 15  ~ "High L2FC",
            TRUE ~ "Neutral"
          )), alpha = 0.7) +
          scale_color_manual(
            values = c(
              "Low L2FC" = "#156082",  # Dark Blue
              "High L2FC" = "#990000", # Deep Red
              "Neutral" = "grey"
            ),
            name = ""  # Removes the legend title
          ) +
          xlab("log2FC") +
          ylab("-log10 padj") +
          ggtitle(comparison_name) +
          theme_minimal() +
          theme(
            panel.grid = element_blank(),  # Removes all gridlines
            plot.title = element_text(hjust = 0.5)
          )

        ggsave(paste0("deseq/plots/volcano_", comparison_name, ".png"), plot = p_volcano, width = 8, height = 6, dpi = 300)
      }
    }
  }
}

message("✅ All pairwise comparisons saved successfully.")
