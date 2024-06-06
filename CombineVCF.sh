#!/bin/bash
set -v #verbose script
set -e #stops script if command fails
# Usage; ./CombineVCF.sh <VCF_FOLDER><OUTPUT_FOLDER>

# Folder with Multiple GFF Files
VCF_FOLDER="$1"

# Folder where VCF will be stored
OUTPUT_FOLDER="$2"

# Create List Of Files
vcf_files=$(ls $VCF_FOLDER*.vcf.gz | sort -V)

bcftools concat $vcf_files -Oz --threads 16 -o "${VCF_FOLDER}/merged.vcf.gz"
tabix -p vcf  "${OUTPUT_FOLDER}/merged.vcf.gz" #create index of vcf file
