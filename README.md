# Genic Region Genomic Prediction

This repository contains two scripts which are part of the pipeline to test how genomic prediciton ability changes based on
genomic relationship matricies made from genic and non-neginc regions of the genome. 
 
CombineVCF.sh can be used to combine merge seperate vcf files. This is useful if the genome has been seperated my chromosome.
Usage; ./CombineVCF.sh <VCF_FOLDER><OUTPUT_FOLDER>

GenestoGmat.sh can be used to take a list of genes and create vcf file for variants only found within those genes. It will
create an output folder with the intermediary files used in the process. 
Usage; ./GenestoGmat.sh <GENE_FILE> <GFF_FILE> <OUTPUT_NAME> <VCF_FILE>

The vcf file create by GenestoGmat.sh can be used to create a genomic relationship matrix. For example using Tassel:

run_pipeline.pl -importGuess "Output_$OUTPUT_NAME/${OUTPUT_NAME}.vcf" -FilterSiteBuilderPlugin -siteMinAlleleFreq 0.05 -endPlugin
-subsetSites $nSITES -KinshipPlugin -method Centered_IBS -endPlugin -export "Output_${OUTPUT_NAME}/${OUTPUT_NAME}_kinship.txt"

If all SNPs are to be used, -subsetSites and $nSITES can be removed.
