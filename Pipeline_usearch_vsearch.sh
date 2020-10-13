#!/bin/bash/
set -e
set -u
set -o pipefail
HOMEFOLDER="/Users/diego/Desktop/Ester/microplastics/raw_reads/"  # This is the full pathname
echo "Home folder is" ${HOMEFOLDER}
MIN=380
MAX=480



export PATH=$PATH:"/Users/diego/Desktop/Ester/Programms/usearch/"
export PATH=$PATH:"/Users/diego/Desktop/Ester/Programms/usearch/rotifer_new/"

cd ${HOMEFOLDER}/
#
#for file in ${HOMEFOLDER}/*.fastq
#do
#cutadapt -u 50 -o "$file.out.fastq" "$file"
#done
#
usearch -fastq_mergepairs *_R1_.fastq.out.fastq -fastq_maxdiffs 10 -fastqout merged.fq -report report.txt -relabel @
##
mothur "#fastq.info(fastq=merged.fq)"
##
./vsearch --fastq_filter merged.fq -fastq_minlen 360 -fastq_maxee 0.5 --fastq_qmax 42 -fastqout merged_f.fastq
##
./vsearch --derep_fulllength merged_f.fastq --output uniques.fa -sizeout -relabel Uniq --relabel_sha1 --relabel_keep
##
usearch -sortbysize uniques.fa -fastaout uniques_ns.fa -minsize 2
usearch -unoise3 uniques_ns.fa -zotus zotus.fa -tabbedout unoise3.txt
./vsearch -uchime_denovo zotus.fa --nonchimeras vsearch_nonchimeras.fasta --sizein --xsize --chimeras vsearch_chimeras.fasta --log logfile_uchime
./vsearch -usearch_global merged.fasta -db vsearch_nonchimeras.fasta -strand plus -id 1.0 -uc Results_mapping.uc -otutabout otu_table_all.txt
./vsearch -sintax zotus.fa  -db silva_16s_v123.fa --tabbedout reads_vsearch_all.sintax --sintax_cutoff 0.8
#
#
#for i in ${HOMEFOLDER}/*_R1.fastq;
#do
#SAMPLE=$(echo ${i} | sed "s/_R1\.fastq//")
#echo ${SAMPLE}_R1.fastq ${SAMPLE}_R2.fastq
#cutadapt -u 50 --minimum-length 100 -o  ${SAMPLE}_temp_R1.fastq \
#-p ${SAMPLE}_temp_R2.fastq  ${SAMPLE}_R1.fastq  ${SAMPLE}_R2.fastq
#
#done
#
#
#
#for i in ${HOMEFOLDER}/*_temp_R1.fastq;
#do
#SAMPLE=$(echo ${i} | sed "s/_temp\_R1\.fastq//")
#cutadapt -u 50 --minimum-length 100 -o ${SAMPLE}_R2_trimmed.fastq -p ${SAMPLE}_R1_trimmed.fastq  ${SAMPLE}_temp_R2.fastq ${SAMPLE}_temp_R1.fastq
#done
#usearch -fastq_mergepairs *_R1_trimmed.fastq -fastq_maxdiffs 10 -fastqout merged.fq -report report.txt -relabel @
###
####
#####— Usearch
####
########usearch -fastx_revcomp SRS969066_R2_trimmed.fastq --fastqout out_R2.fq
####
#usearch -fastq_mergepairs *_R1_trimmed.fastq -fastq_maxdiffs 10 -fastqout merged.fq -report report.txt -relabel @ #
#####
######— go to mother ——————————————————————
####mothur "#fastq.info(fastq=merged.fq);screen.seqs(fasta=merged.fasta, minlength=${MIN}, maxlength=${MAX}, maxhomop=6)"
####
####
####
#####OR find length of your sequence ———————
###vsearch --fastq_filter merged.fq -fastq_minlen 400 -fastq_maxee 0.5 --fastq_qmax 42 -fastqout merged_f.fastq
####usearch -fastq_filter merged.fq -fastq_minlen 400 -fastq_maxee 0.5 -fastqout merged_f.fastq
####usearch -fastx_uniques merged_f.fastq -fastaout uniques.fa -sizeout -relabel Uniq
###vsearch --derep_fulllength merged_f.fastq --output uniques.fa -sizeout -relabel Uniq --relabel_sha1 --relabel_keep
###usearch -sortbysize uniques.fa -fastaout uniques_ns.fa -minsize 2
######--ZOTU
###usearch -unoise3 uniques_ns.fa -zotus zotus.fa -tabbedout unoise3.txt
###
##
######
#######either:
###usearch -otutab merged.fq -zotus zotus.fa -otutabout zotutab.txt -mapout zmap.txt
###usearch -sintax zotus.fa -db silva_16s_v123.fa -tabbedout otus.sintax -strand both -sintax_cutoff 0.8
######OR:
##vsearch -uchime_denovo zotus.fa --nonchimeras vsearch_nonchimeras.fasta --sizein --xsize --chimeras vsearch_chimeras.fasta --log logfile_uchime
###
##vsearch -usearch_global merged.fasta -db vsearch_nonchimeras.fasta -strand plus -id 1.0 -uc Results_mapping.uc -otutabout otu_table.txt
#####
####
##vsearch -sintax zotus.fa -db silva_16s_v123.fa --tabbedout reads_vsearch.sintax --sintax_cutoff 0.8
##
###
##usearch -sintax vsearch_nonchimeras.fasta -db rdp_16s_v16.fa -tabbedout otus_vsearch.sintax -strand both -sintax_cutoff 0.8
###
##vsearch -cluster_fast uniques_ns.fa -id 1.0 --sizein --sizeout --relabel OTU_ --centroids rep_seq.fasta -log logfile_cluster
##vsearch -uchime_denovo rep_seq.fasta --nonchimeras vsearch_nonchimeras.fasta --sizein --xsize --chimeras vsearch_chimeras.fasta --log logfile_uchime
##
##
##
##vsearch -usearch_global merged.fasta -db vsearch_nonchimeras.fasta -strand plus -id 1.0 -uc Results_mapping.uc -otutabout otu_table_99.txt
##
##
##
##
##set -e
##set -u
##set -o pipefail
##HOMEFOLDER="/Users/diego/Desktop/Ester/Programms/usearch/rotifer_new/"  # This is the full pathname
##echo "Home folder is" ${HOMEFOLDER}
##MIN=320
##MAX=400
##
##export PATH=$PATH:"/Users/diego/Desktop/Ester/Programms/usearch/"
##export PATH=$PATH:"/Users/diego/Desktop/Ester/Programms/usearch/rotifer_new/"
##
##cd ${HOMEFOLDER}/
##
##for i in ${HOMEFOLDER}/*_R1.fastq;
##do
##SAMPLE=$(echo ${i} | sed "s/_R1\.fastq//")
##echo ${SAMPLE}_R1.fastq ${SAMPLE}_R2.fastq
##cutadapt -u 50 --minimum-length 100 -o  ${SAMPLE}_temp_R1.fastq \
##-p ${SAMPLE}_temp_R2.fastq  ${SAMPLE}_R1.fastq  ${SAMPLE}_R2.fastq
##
##done
##
##
##
##for i in ${HOMEFOLDER}/*_temp_R1.fastq;
##do
##SAMPLE=$(echo ${i} | sed "s/_temp\_R1\.fastq//")
##cutadapt -u -50 --minimum-length 100 -o ${SAMPLE}_R2_trimmed.fastq -p ${SAMPLE}_R1_trimmed.fastq  ${SAMPLE}_temp_R2.fastq ${SAMPLE}_temp_R1.fastq
##done
##
##
##
##usearch -fastq_mergepairs *_R1_trimmed.fastq -fastq_maxdiffs 10 -fastqout merged.fq -report report.txt -relabel @
##
#mothur "#fastq.info(fastq=merged.fq)"
#
#vsearch --fastq_filter merged.fq -fastq_minlen 360 -fastq_maxee 0.5 --fastq_qmax 42 -fastqout merged_f.fastq
#
#vsearch --derep_fulllength merged_f.fastq --output uniques.fa -sizeout -relabel Uniq --relabel_sha1 --relabel_keep
#
#usearch -sortbysize uniques.fa -fastaout uniques_ns.fa -minsize 2
#usearch -unoise3 uniques_ns.fa -zotus zotus.fa -tabbedout unoise3.txt
#vsearch -uchime_denovo zotus.fa --nonchimeras vsearch_nonchimeras.fasta --sizein --xsize --chimeras vsearch_chimeras.fasta --log logfile_uchime
#vsearch -usearch_global merged.fasta -db vsearch_nonchimeras.fasta -strand plus -id 1.0 -uc Results_mapping.uc -otutabout otu_table_all.txt
#vsearch -sintax zotus.fa  -db silva_16s_v123.fa --tabbedout reads_vsearch_all.sintax --sintax_cutoff 0.8
#
##
##
##!/bin/bash/
##set -e
##set -u
##set -o pipefail
##HOMEFOLDER="/Users/diego/Desktop/Ester/Programms/usearch/rotifer_new/Experiment"  # This is the full pathname
##echo "Home folder is" ${HOMEFOLDER}
##MIN=320
##MAX=400
##
##export PATH=$PATH:"/Users/diego/Desktop/Ester/Programms/usearch/"
##export PATH=$PATH:"/Users/diego/Desktop/Ester/Programms/usearch/rotifer_new/Experiment"
##
##cd ${HOMEFOLDER}/
##
##
