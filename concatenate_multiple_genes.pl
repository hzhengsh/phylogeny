#!perl -w

use warnings;
use strict;

opendir (DIR,"$ARGV[0]") or die "can't open file $ARGV[0]";
open (OUT,">$ARGV[1]") or die "can't create file $ARGV[1]";

my %align_length = ();
my %all_names = ();
my %all_seqs = ();
my $total_length = 0;
foreach my $file (readdir DIR){
#	if($file =~ /\.phy/){
	if($file ne "." && $file ne ".."){
		open (IN,"$ARGV[0]/$file") or die "can't open file $file";
		my $line = <IN>;
		$line =~ s/\s+$//ig;
		my @fields = split /\s+/,$line;
		$align_length{$file} = $fields[1];
		$total_length += $fields[1];
		while(my $line = <IN>){
			$line =~ s/\s+$//ig;
			my @fields = split /\s+/,$line;
			$all_names{$fields[0]} = 1;
			$all_seqs{$file}->{$fields[0]} = $fields[1];
		}
		close IN;
	}
}

my $seq_num = scalar(keys %all_names);
print OUT "$seq_num $total_length\n";
foreach my $key (sort keys %all_names){
	print OUT "$key	";
	foreach my $subKey (sort keys %all_seqs){
		if(exists($all_seqs{$subKey}->{$key})){
			print OUT "$all_seqs{$subKey}->{$key}";
		}
		else{
			for(my $i=0;$i<$align_length{$subKey};$i++){
				print OUT "-";
			}
		}
	}
	print OUT "\n";
}
