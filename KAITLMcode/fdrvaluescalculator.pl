#!/usr/bin/perl
use Math::Trig;

my @filename = ();
my @magparfilename = ();
my @magparvalues = ();
my @fdrsigmavalues = ();


#clear the final values lists first before appending values to them to prevent making aribtrarily long lists with old values

$fdrvaluesfilename = 'fdrvalues.phot.list';
$fdrvaluessortedfilename = 'fdrvalues.phot.sorted.list';

	open fdrvaluesfile, ">", $fdrvaluesfilename or die $!;
	print fdrvaluesfile '';
	close(fdrvaluesfile);


	open fdrvaluessortedfile, ">", $fdrvaluessortedfilename or die $!;
	print fdrvaluessortedfile '';
	close(fdrvaluessortedfile);
	

$fdrcounter = 0;
open fdrsublist, "<fdrsub.list" or die $!;
while(<fdrsublist>)
{
	chomp;
	$filename[$fdrcounter] = $_;
	$magparfilename[$fdrcounter] = $_ . ".fdr.mag.par";
	@magparvalues = ();
	open magparfile, "<", $magparfilename or die $!;
	while(<magparfile>)
	{
			chomp;
			@magparvalues = (@magparvalues, [split(/ +/)]);
			$fdrsigmavalue[$fdrcounter] = $magparvalues[2]/$magparvalues[1]/$magparvalues[0];
	}
	close(magparfile);
	
	open fdrvaluesfile, ">>", $fdrvaluesfilename or die $!;
	print fdrvaluesfile $filename[$fdrcounter] . " " . $fdrsigmavalue[$fdrcounter] . "\n";
	close(fdrvaluesfile);


	
$fdrcounter++;
}	

close(fdrsublist);

#sort {$a->[0] cmp $b->[0]}

	#open fdrvaluessortedfile, ">>", $fdrvaluessortedfilename or die $!;
	#zzz print fdrvaluessortedfile print stuff here
	#close(fdrvaluessortedfile);




