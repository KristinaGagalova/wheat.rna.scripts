#!/bin/bash

cDNA_file="./indices/ncbi_dataset/data/GCF_018294505.1/rna.fna"
index_file="./indices/ncbi_dataset/data/GCF_018294505.1/rna.idx"

kallisto index -i "$index_file" "$cDNA_file"