## The repo contains RNAseq data analysis of wheat samples

### Pipeline
* BBduk reads trimming/filtering
* Kallisto quantification
* DESeq2 differential expression analysis
* Cluster Profile for DE genes

## Additional checks on reads
- [ ] RNASeq strandedness     
- [ ] Number of % of aligned reads - this can be done with the ```log``` file of Kallisto. [This](https://github.com/MultiQC/test-data/blob/main/data/modules/kallisto/issue_1746/kallisto_mapping_Dcor-1_scaff1_21.log) is an example output that we can parse with [MultiQC](https://docs.seqera.io/multiqc/modules/kallisto).
