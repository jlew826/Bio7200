#!/bin/bash

calle= false #initialize calle variable as false until option e is called
callz= false #initialize callz variable as false until option z is called
_V= false #initialize _V variable as false until option v is called
calli= false #initialize calli variable as false until option i is called

#usage information
usage() { echo "Usage: $0 [-a input reads file pair 1 name] [-b input reads file pair 2 name] [-r reference genome file name][-o output file name][-e][-f mills file name][-z][-v][-i][-h]" 1>&2; exit 1; }

# 2) input command line options
while getopts "a:b:r:o:ef:zvih" OPTION; do
    case $OPTION in
	a) #read 1
	    read1=$OPTARG
      ;;
	b) #read 2
	    read2=$OPTARG
	    ;;
	r) #reference
      reference=$OPTARG
      ;;
  o) #outputfile
      outputfile=$OPTARG
      ;;
  e) #reads realign function
      calle= true
      ;;
  f) #mills file
      mills=$OPTARG
      ;;
  z) #variant calling function
      callz= true
      ;;
  v) #verbose option
      _V= true
	    ;;
  i) #indexing output bam file
      calli= true
      ;;
	h) #print usage information
	    usage
      exit
	    ;;
  *) #print usage information
      usage
      exit;;
    esac
done
shift "$(($OPTIND -1))"

#makes sure all options that require arguments have arguments
if [ -z $read1 ] || [ -z $read2 ] || [ -z $reference ] || [ -z $outputfile ] || [ -z $mills ]
then
   usage
   exit
fi

mv data/* $PWD #move everything in data directory up to week7/ directory
mv lib/* $PWD #move everying in lib directory up to week7/ directory
mv output/* $PWD #move everying in output directory up to week7/ directory

#checks to see if reads files exist; indicates which one doesn't exist
if [[ $_V -eq true ]]; then
  echo "+++CHECKING TO SEE INPUT FILES EXIST+++" #verbose option
fi

if [ ! -e $read1 ] && [ ! -e $read2 ]; then
  echo "Error: both read files do not exist."
  exit
elif [ ! -e $read1 ]; then
  echo "Error: $read1 (-a argument) file does not exist."
  exit
elif [ ! -e $read2 ]; then
  echo "Error: $read2 (-b argument) file does not exist."
  exit
fi

#checks to see if reference file exists
if [ ! -e $reference ]; then
  echo "Error: $reference (-r argument) file does not exist."
  exit
fi

#function to perform reads re-aligmnent
readsrealign(){
  # 3a) Mapping
  bwa index $reference
  bwa mem -R '@RG\tID:foo\tSM:bar\tLB:library1' $reference $read1 $read2 > lane.sam
  samtools fixmate -O BAM lane.sam lane_fixmate.bam
  samtools sort -O BAM -o lane_sorted.bam -T lane_temp lane_fixmate.bam

  #create fasta index file
  samtools faidx $reference

  #create fast sequence dictionary file
  java -jar picard.jar CreateSequenceDictionary R=$reference

  #index sorted bam file
  samtools index lane_sorted.bam

  # 3 b i) Improvement, Realign
  java -Xmx2g -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R $reference -I lane_sorted.bam -o lane.intervals --known $mills
  java -Xmx4g -jar GenomeAnalysisTK.jar -T IndelRealigner -R $reference -I lane_sorted.bam -targetIntervals lane.intervals -known $mills -o lane_realigned.bam
}

#function to index your output BAM file
indexoutputbam(){
  #3 b iv) Improvment, Index bam
  samtools index lane_realigned.bam
}

#function to output VCF file - should be gunzipped (*.vcf.gz)
variantcalling(){
  # 3 c) Variant Calling
  bcftools mpileup -Ou -f $reference lane_sorted.bam | bcftools call -vmO z -o $outputfile.gz
  tabix -p vcf $outputfile.gz
  bcftools stats -F $reference -s - $outputfile.gz > $outputfile.gz.stats
  mkdir plots
  plot-vcfstats -p plots $outputfile.gz.stats
}

#if option e is called, readsrealign commands are executed
if [[ $calle -eq true ]]; then
  if [[ $_V -eq true ]]; then
    echo "+++PERFORMING READS RE-ALIGNMENT+++" #verbose option
  fi
  readsrealign
fi

#if option i is called, indexoutputbam command is executed
if [[ $calli -eq true ]]; then
  if [[ $_V -eq true ]]; then
    echo "+++INDEXING THE OUTPUT BAM FILE+++" #verbose option
  fi
  indexoutputbam
fi

#if option z is called, variantcalling commands are executed
if [[ $callz -eq true ]]; then
  if [[ $_V -eq true ]]; then
    echo "+++CREATING OUTPUT VCF FILE+++" #verbose option
  fi
  if [ ! -e $outputfile ]; then #checks to see if output VCF file does not exist
    variantcalling
  else
    echo "WARNING: $outputfile file exists. Do you want to overwrite? (y/n)" #if it exists, ask the user what he/she wants to do
    read ANSWER
    [ "$ANSWER" = "y" ] && variantcalling || echo "Ok, will not overwrite."
  fi
fi

if [[ $_V -eq true ]]; then
  echo "+++CLEANING UP DIRECTORY STRUCTURE+++" #verbose option
fi

mv $read1 data/
mv $read2 data/
mv $mills data/
mv $reference data/
mv GenomeAnalysisTK.jar lib/
mv picard.jar lib/
mv $outputfile.gz output/
mv README.txt output/
mv $reference.* tmp/
mv $mills.* tmp/
mv $outputfile.* tmp/
mv lane* tmp/
mv *.dict tmp/
mv *.gz tmp/
mv *.vcf tmp/
mv plots/ tmp/
