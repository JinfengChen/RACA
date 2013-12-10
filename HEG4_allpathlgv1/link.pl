#!/usr/bin/perl
use Getopt::Long;

GetOptions (\%opt,"go","help");


my $help=<<USAGE;
perl $0 --go
USAGE

#ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsHEG4_RAW/axt_chain/Chr* ./MSU7.chain.net/MSU7/HEG4/chain/
#ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsHEG4_RAW/prenet_net/Chr* ./MSU7.chain.net/MSU7/HEG4/net/
#ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOGL/axt_chain/Chr* ./MSU7.chain.net/MSU7/OGL/chain/
#ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOGL/prenet_net/Chr* ./MSU7.chain.net/MSU7/OGL/net/
#ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOPU/axt_chain/Chr* ./MSU7.chain.net/MSU7/OPU/chain/
#ln -s /rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOPU/prenet_net/Chr* ./MSU7.chain.net/MSU7/OPU/net/

if ($opt{help} or keys %opt < 1){
    print "$help\n";
    exit();
}

linkfile("/rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsHEG4_ALLPATHLGv1.GC/axt_chain","./MSU7.chain.net/MSU7/HEG4/chain","chain");
linkfile("/rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsHEG4_ALLPATHLGv1.GC/prenet_net","./MSU7.chain.net/MSU7/HEG4/net", "net");
linkfile("/rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOGL/axt_chain","./MSU7.chain.net/MSU7/OGL/chain","chain");
linkfile("/rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOGL/prenet_net","./MSU7.chain.net/MSU7/OGL/net", "net");
linkfile("/rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOPU/axt_chain","./MSU7.chain.net/MSU7/OPU/chain","chain");
linkfile("/rhome/cjinfeng/HEG4_cjinfeng/GenomeAlign/Lastz/output/MSU7vsOPU/prenet_net","./MSU7.chain.net/MSU7/OPU/net", "net");

########
sub linkfile
{
my ($src,$tar,$suffix)=@_;
my @file=glob("$src/*.$suffix");
`rm $tar/*.$suffix`;
foreach my $f (@file){
   if ($f =~ /\/(Chr(\d+)).*\.$suffix/){
      my $chr=$1;
      #my $chr1=$chr;
      #$chr=~tr/C/c/;
      #$chr="chrX" if ($2 == 12);
      #$chr1="Chr12" if ($2 == 12);
      my $link=$tar."/$chr.$suffix";
      #my $link1=$tar."/$chr1.$suffix";
      `ln -s $f $link`;
      #`ln -s $f $link1`;
   }
}
}
 
