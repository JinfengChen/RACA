echo "prepare data for RACA run"
echo "cp config files into run directory and edit the directory accordingly"
cp ../HEG4_RAW/Makefile ./
cp ../HEG4_RAW/config.SFs.tmp ./
cp ../HEG4_RAW/params.tmp ./
cp ../HEG4_RAW/Makefile.SFs ./
cp ../HEG4_RAW/runRACA.sh ./
cp ../HEG4_RAW/reliable_adjs.txt ./

echo "create dir for chain/net"
mkdir MSU7.chain.net
mkdir MSU7.chain.net/MSU7
mkdir MSU7.chain.net/MSU7/OGL
mkdir MSU7.chain.net/MSU7/OGL/chain
mkdir MSU7.chain.net/MSU7/OGL/net
mkdir MSU7.chain.net/MSU7/OPU
mkdir MSU7.chain.net/MSU7/OPU/chain
mkdir MSU7.chain.net/MSU7/OPU/net
mkdir MSU7.chain.net/MSU7/HEG4
mkdir MSU7.chain.net/MSU7/HEG4/chain
mkdir MSU7.chain.net/MSU7/HEG4/net

echo "link the chain/net files"
ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsHEG4_ALLPATHLGv1.GC/axt_chain/Chr* ./MSU7.chain.net/MSU7/HEG4/chain/
ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsHEG4_ALLPATHLGv1.GC/prenet_net/Chr* ./MSU7.chain.net/MSU7/HEG4/net/
ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOGL/axt_chain/Chr* ./MSU7.chain.net/MSU7/OGL/chain/
ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOGL/prenet_net/Chr* ./MSU7.chain.net/MSU7/OGL/net/
ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOPU/axt_chain/Chr* ./MSU7.chain.net/MSU7/OPU/chain/
ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOPU/prenet_net/Chr* ./MSU7.chain.net/MSU7/OPU/net/
echo "use perl to link files, because the name should be Chr1.net and Chr1.chain. Also modified readNet.c in code. Original has last one as chrX"
perl link.pl --go

echo "create tree files"
echo "((MSU7:0.001,HEG4@:0.001):0.025,OPU:0.025);" > tree.OPU.txt
echo "((MSU7:0.001,HEG4@:0.001):0.005,OGL:0.005);" > tree.OGL.txt

echo "target scaffold"
ln -s /rhome/cjinfeng/BigData/01.Rice_genomes/HEG4/00.Assembly/HEG4_ALLPATHLG_v1/HEG4.allpathlg.GC.v1.noIUPAC.fasta HEG4.fa
perl /rhome/cjinfeng/software/bin/fastaDeal.pl --attr id:len HEG4.fa > HEG4.size

echo "prepare reads"
echo "in get_interblock_score.pl, need to parse library from read files like FC70_1_illuminaGAIIx500.HEG4_RAW.soap.SE.position"
perl prepareReads3.pl --soap /rhome/cjinfeng/BigData/01.Rice_genomes/HEG4/00.SOAP/HEG4_allpathlgv1 > log 2> log2 &

echo "run"
make
qsub -q batch -l nodes=1:ppn=32 runRACA.sh
echo "skip collect reads and coverage step, only modify IGNORE_ADJS_WO_READS which indiate use pe/synteny or both"
qsub runRACA_PE.sh

echo "build chromosome"
perl BuildChr.pl --rec ./Out_RACA_PE2/rec_chrs.refined.txt --scaffold HEG4.fa --outfile HEG4.RACA.PE
cat HEG4.RACA.PE HEG4.RACA.PE.leftscaffold.fa > HEG4.RACA.PE.all.fa


echo "check how many links"
awk '$5>1' ./Out_RACA_PE2/SFs/inter_block_scores.txt | wc -l

