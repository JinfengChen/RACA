#!/bin/sh
#PBS -l nodes=1:ppn=16
#PBS -l mem=20gb
#PBS -l walltime=100:00:00

cd $PBS_O_WORKDIR
perl /rhome/cjinfeng/software/tools/RACA/RACA-0.9.1/Run_RACA.pl params.PE.txt > log 2> log2 
echo "Done"

