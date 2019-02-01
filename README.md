# Bio7200
## Programming for Bioinformatics
Various programming projects converting data into biological knowledge

### Lab 6: Basic shell concepts
Working with FASTA files.

### Lab 7: SNP-calling pipeline
Creating	a	pipeline	for	calling	Single	Nucleotide	Polymorphisms (SNPs) by 1) aligning	genomic	reads	to	a	reference	genome 2) processing	the	alignment	file	(conversion,	sorting,	alignment	improvement) and 3) calling	the	variants
using the following tools: [bwa](http://bio-bwa.sourceforge.net/), [samtools/HTS package](http://www.htslib.org/), [GATK](https://software.broadinstitute.org/gatk/).

### Lab 8: Summarizing BED Files and Finding Gene Coordinates
Summarizes an input Browser Extensible Data (BED) file by displaying the following data: 
1) The total number of entries in the file
2) The total length of the entries in the file
3) The number of entries on each strand
4) The longest entry
5) The shortest entry
6) The average and standard deviation of the gene lengths

Reads in three files from the UCSC hg19/database (ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/) in a specific logical order and returns the coordinates for the genes of interest listed in the InfectiousDisease-GeneSets.txt file.

### Lab 9: Functional Genomic Analysis
Identifying orthologous genes between different genomes using [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download). Takes in an input of two sets of protein or nucleotide sequences- one from each genome, creates a database from each, query each set against the opposite database, and gives an output of sequence pairs which are reciprocal best hits.

### Lab 10: FASTA Converter, K-mer Counting, and Needleman–Wunsch Algorithm
1) Converts the following file types into FASTA format: [EMBL](https://www.genomatix.de/online_help/help/sequence_formats.html#EMBL), [FASTQ](https://www.genomatix.de/online_help/help/sequence_formats.html#FASTQ), [GenBank](https://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html),
 [MEGA](http://jordan.biology.gatech.edu/biol7200/MegaFormatDescription.docx), [PIR](http://www.bioinformatics.nl/tools/crab_pir.html).
 2) Reads in a FASTA file and computes the counts of all k-mers present in the input file and outputs in alphabetical order.
 3) Takes in an input of two FASTA files, and uses the [Needleman–Wunsch (NW) Algorithm](https://en.wikipedia.org/wiki/Needleman%E2%80%93Wunsch_algorithm) to obtain optimal global alignment.
 
### Lab 11: Overlapping Genomic Coordinates
Takes an input of two [BED files](https://genome.ucsc.edu/FAQ/FAQformat#format1) and finds the overlapping genomic coordinates, allows an option of minimum percentage overlap.

### Lab 12: BioPerl
Using [BioPerl](https://bioperl.org/) to manipulate sequences: converting file formats and using BLAST to use a parser to find the top two best hits for each sequence.
