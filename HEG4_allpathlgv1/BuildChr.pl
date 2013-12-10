#!/usr/bin/perl
use Getopt::Long;

GetOptions (\%opt,"rec:s","scaffold:s","outfile:s","help");


my $help=<<USAGE;
perl $0 --rec --scaffold --outfile
--rec: rec_chr.refined.txt
--scaffold: orginal scaffold
--outfile: output genome fasta
USAGE


if ($opt{help} or keys %opt < 1){
    print "$help\n";
    exit();
}

$opt{outfile} ||= "RACA.genome.fa";
my $refseq=getfastaseq($opt{scaffold});
buildchr($opt{rec},$refseq,$opt{outfile});

######
sub getfastaseq
{
my ($file)=@_;
my %hash;
### read fasta file and output fasta if id is found in list file
$/=">";
open IN,"$file" or die "$!";
while (<IN>){
    next if (length $_ < 2);
    my @unit=split("\n",$_);
    my $head=shift @unit;
    my $seq=join("\n",@unit);
    $seq=~s/\>//g;
    $seq=~s/\n//g;
    $seq=~s/\t//g;
    $seq=~s/\s//g;
    print OUT ">$head\n$seq\n";
    $hash{$head}=$seq; 
}
close IN;
$/="\n";
return \%hash;
}


#1a      0       1066516 Scaffold400     0       1066516 -
#1a      1066516 1066616 GAPS
#1a      1066616 3416008 Scaffold475     0       2349392 +
#1a      3416008 3690003 Scaffold693     0       273995  -
sub buildchr
{
my ($file,$refseq,$out)=@_;
my %chr;
my %record;
open IN, "$file" or die "$!";
while(<IN>){
    chomp $_;
    next if ($_=~/^$/);
    my @unit=split("\t",$_);
    if ($unit[3] =~ /GAPS/){
       my $len=$unit[2]-$unit[1];
       my $gap="N" x $len;
       #print "$len\n$gap\n";
       $chr{$unit[0]}.=$gap;
    }else{
       my $len=$unit[5]-$unit[4];
       my $seq=substr($refseq->{$unit[3]},$unit[4],$len);
       $record{$unit[3]}=1;
       if ($unit[6] eq "+"){
          $chr{$unit[0]}.=$seq;
       }else{
          $chr{$unit[0]}.=revcom($seq);
       }
    }
}
close IN;


open OUT, ">$out" or die "$!";
foreach my $c (sort keys %chr){
     #print "$c\n$chr{$c}\n";
     my $seqline=formatseq($chr{$c},50);
     my $chr="Superscaffold$c";
     print OUT ">$chr\n$seqline\n";
}
close OUT;

open OUT, ">$out.leftscaffold.fa" or die "$!";
foreach my $s (sort keys %$refseq){
     unless (exists $record{$s}){
        my $seqline=formatseq($refseq->{$s},50);
        print OUT ">$s\n$seqline\n"
     }
}
close OUT;

`cat $out $out.leftscaffold.fa > $out.all.fa`;
`perl /rhome/cjinfeng/HEG4_cjinfeng/sumNxx.pl $out > $out.Nxx`;
`perl /rhome/cjinfeng/HEG4_cjinfeng/sumNxx.pl $out.leftscaffold.fa > $out.leftscaffold.fa.Nxx`;
`perl /rhome/cjinfeng/HEG4_cjinfeng/sumNxx.pl $out.all.fa > $out.all.fa.Nxx`;
#return \%chr;
}
 

sub revcom
{
my ($seq)=@_;
my $rev=reverse $seq;
$rev=~tr/ATGCatgc/TACGtacg/;
return $rev;
}

sub formatseq
{
### format a single line sequence into lines with user specific length
my ($seq,$step)=@_;
my $length=length $seq;
my $run=int ($length/$step);
my $newseq;
for(my $i=0;$i<=$run;$i++){
   my $start=$i*$step;
   my $line=substr($seq,$start,$step);
   $newseq.="$line\n";
}
return $newseq;
}





