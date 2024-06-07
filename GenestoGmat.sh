#!/bin/bash
set -v #verbose script
set -e #stops script if command fails
# Usage; ./GenestoGmat.sh <CSV_FILE> <GFF_FILE> <OUTPUT_NAME> <VCF_FILE>

#Check if correct number of arguments are provided
#if the number of arguments  $# are not equal (-ne) to 3, then echo
#message
if [ "$#" -ne 4 ]; then
        echo "Usage: $0 <CSV_FILE> <GFF_FILE> <OUTPUT_NAME> <VCF_FILE>"
        exit 1
fi

# CSV file with gene list (genes are in the second column)
CSV_FILE="$1"

# GFF file to filter
GFF_FILE="$2"

# Output file for filtered GFF
OUTPUT_NAME="$3"

# VCF folder name
VCF_FILE="$4"

# Create Output Folder
mkdir -p "Output_$OUTPUT_NAME"

# Extract gene names
grep -f "$CSV_FILE" "$GFF_FILE" >>"Output_$OUTPUT_NAME/$OUTPUT_NAME.gff"
echo "$GFF_FILE filtered based on CSV_FILE. Output written to: $OUTPUT_NAME in Output_$OUTPUT_NAME"

# Make bed File from GFF file
gff2bed < "Output_$OUTPUT_NAME/$OUTPUT_NAME.gff" > "Output_$OUTPUT_NAME/$OUTPUT_NAME.bed"
echo ".bed file made from filtered $GFF_FILE"

#if bed file has a chr in front of chrom, replace
if grep -q chr "Output_$OUTPUT_NAME/$OUTPUT_NAME.bed"; then
	sed 's/chr//g' "Output_$OUTPUT_NAME/$OUTPUT_NAME.bed" > "Output_$OUTPUT_NAME/${OUTPUT_NAME}_no_chr.bed"
	#sed cant read {} in the variable name
	echo "chr removed from chromosome name in bed file."
	mv "Output_$OUTPUT_NAME/${OUTPUT_NAME}_no_chr.bed" "Output_$OUTPUT_NAME/$OUTPUT_NAME.bed"
fi


#filter vcf file by bed file of genes of interest
bcftools view -R "Output_$OUTPUT_NAME/${OUTPUT_NAME}.bed" "${VCF_FILE}" | bcftools sort -o "Output_$OUTPUT_NAME/${OUTPUT_NAME}.vcf"
echo "VCF file filtered based on $OUTPUT_NAME.bed"
#bcftools stats Output_$OUTPUT_NAME/${OUTPUT_NAME}.vcf"

#Create distance matrix
#/home1/aloeb/GageRot/input/tassel-5-standalone/run_pipeline.pl -importGuess "Output_$OUTPUT_NAME/${OUTPUT_NAME}.vcf" -FilterSiteBuilderPlugin -siteMinAlleleFreq 0.05 -endPlugin -subsetSites 15000 -KinshipPlugin -method Centered_IBS -endPlugin -export "Output_${OUTPUT_NAME}/${OUTPUT_NAME}_kinship.txt"
