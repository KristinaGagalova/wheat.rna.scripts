import os
import pandas as pd

# Define the directory containing the abundance files
abundance_dir = "./quant"

# Check if the abundance directory exists
if not os.path.exists(abundance_dir):
    raise FileNotFoundError(f"The directory {abundance_dir} does not exist.")

# Initialize an empty list to store dataframes
dataframes = []

# Iterate through all subdirectories in abundance_dir
for sample in os.listdir(abundance_dir):
    sample_dir = os.path.join(abundance_dir, sample)
    
    # Check if the sample_dir is a directory
    if os.path.isdir(sample_dir):
        file_path = os.path.join(sample_dir, "abundance.tsv")
        
        # Check if abundance.tsv exists
        if os.path.exists(file_path):
            # Extract sample ID from the directory name
            sample_id = sample
            
            # Read the abundance.tsv file
            df = pd.read_csv(file_path, sep="\t")
            
            # Select target_id and est_counts columns
            df = df[["target_id", "tpm"]]
            
            # Rename est_counts column to the sample ID
            df = df.rename(columns={"tpm": sample_id})
            
            # Append the dataframe to the list
            dataframes.append(df)
        else:
            print(f"Warning: {file_path} not found. Skipping.")
    else:
        print(f"Warning: {sample_dir} is not a directory. Skipping.")

# Check if any dataframes were loaded
if not dataframes:
    raise RuntimeError("No abundance.tsv files found in the specified directory.")

# Merge all dataframes on target_id
combined_df = dataframes[0]
for df in dataframes[1:]:
    combined_df = combined_df.merge(df, on="target_id", how="outer")

# Save the combined dataframe to a CSV file
output_file = "./combined_abundance_table.csv"
combined_df.to_csv(output_file, index=False)

print(f"Combined table saved to {output_file}")
