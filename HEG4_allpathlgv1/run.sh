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
