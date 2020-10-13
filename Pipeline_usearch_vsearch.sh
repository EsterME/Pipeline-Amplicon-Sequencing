#!/bin/bash/
set -e
set -u
set -o pipefail
HOMEFOLDER=""  # This is the full pathname
echo "Home folder is" ${HOMEFOLDER}
MIN=380
MAX=480




cd ${HOMEFOLDER}/
#

usearch -fastq_mergepairs *_R1_.fastq.out.fastq -fastq_maxdiffs 10 -fastqout merged.fq -report report.txt -relabel @
##
mothur "#fastq.info(fastq=merged.fq)"
##
vsearch --fastq_filter merged.fq -fastq_minlen 360 -fastq_maxee 0.5 --fastq_qmax 42 -fastqout merged_f.fastq
##
vsearch --derep_fulllength merged_f.fastq --output uniques.fa -sizeout -relabel Uniq --relabel_sha1 --relabel_keep
##
usearch -sortbysize uniques.fa -fastaout uniques_ns.fa -minsize 2
usearch -unoise3 uniques_ns.fa -zotus zotus.fa -tabbedout unoise3.txt
vsearch -uchime_denovo zotus.fa --nonchimeras vsearch_nonchimeras.fasta --sizein --xsize --chimeras vsearch_chimeras.fasta --log logfile_uchime
vsearch -usearch_global merged.fasta -db vsearch_nonchimeras.fasta -strand plus -id 1.0 -uc Results_mapping.uc -otutabout otu_table_all.txt
vsearch -sintax zotus.fa  -db silva_16s_v123.fa --tabbedout reads_vsearch_all.sintax --sintax_cutoff 0.8
#

