#!/usr/bin/perl
use Getopt::Long;

GetOptions (\%opt,"soap:s","help");


my $help=<<USAGE;
perl $0 --soap
--soap: directory where the soap result located
USAGE


if ($opt{help} or keys %opt < 1){
    print "$help\n";
    exit();
}
my $outdir="HEG4reads";
`mkdir $outdir` unless (-f $outdir);
my $refgroup=readgroup("in_groups.HEG4_RAW.csv");
my $reflib  =readlib("in_libs.HEG4_RAW.csv");
read2position($opt{soap},$refgroup);

#################
#1/2	length	strand	chromosome	position
#1       60      -       Scaffold36      2715103
sub read2position
{
my ($file,$group)=@_;
my @reads=glob("$file/*.soap.*E");
open LIB, ">readmapping_lib.txt" or die "$!";
foreach my $read (@reads){
  #print "$read\n";
  my $head;
  my $lib;
  if ($read=~/HEG4_RAW\/((.*?).HEG4_RAW.soap.*)/){
     $head=$1;
     $lib=$2;
  }
  print LIB "$head.position\t$group->{$lib}\n";

  open OUT, ">$outdir/$head.position" or die "$!";
  open IN, "$read" or die "$!";
  while(<IN>){
    chomp $_;
    next if ($_=~/^$/);
    my @unit=split("\t",$_);
    if ($unit[3] == 1){ ## uniq mapped read pair
       $unit[4]= $unit[4] eq "a" ? 1 : 2;
       print OUT "$unit[4]\t$unit[5]\t$unit[6]\t$unit[7]\t$unit[8]\n";
    }
  }
  close IN;
  close OUT;

}
close LIB;
}

#####
#illuminaGAIIx_200_2.3,HEG4_RAW,HEG4,fragment,1,148,25,,,inward,0,0
#illuminaGAIIx_500,HEG4_RAW,HEG4,jumping,1,,,433,27,inward,0,0
sub readlib
{
my ($file)=@_;
my %hash;
open OUT, ">insertsize_sd.txt" or die "$!";
open IN, "$file" or die "$!";
<IN>;
while(<IN>){
    chomp $_;
    next if ($_=~/^$/);
    my @unit=split(",",$_);
    $hash{$unit[0]}=$unit[3]=~/fragment/ ? [$unit[5],$unit[6]] : [$unit[7],$unit[8]];
    my $size=$unit[3]=~/fragment/ ? $unit[5] : $unit[7];
    my $sd  =$unit[3]=~/fragment/ ? $unit[6] : $unit[8];
    print OUT "$unit[0]\t$size\t$size\t$sd\t$sd\n";
}
close IN;
close OUT;
return \%hash;
}

#jump_500_P1,illuminaGAIIx_500,/rhome/cjinfeng/HEG4_cjinfeng/fastq/errorcorrection/soapec/HEG4_0_500bp/FC52_7_?.fq
sub readgroup
{
my ($file)=@_;
my %hash;
open IN, "$file" or die "$!";
<IN>;
while(<IN>){
    chomp $_;
    next if ($_=~/^$/);
    my @unit=split(",",$_);
    my $head;
    if ($unit[2]=~ "HEG4.*\/(.*?)\.fq" ){
      $head=$1;
    }
    $head=~s/\_p*\?//;
    #print "$head\n"; 
    $hash{$head}=$unit[1];
}
close IN;
return \%hash;
}

