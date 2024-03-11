#!/usr/bin/perl
use Math::Trig;

my $snxcoordbefore = 233.411;
my $snycoordbefore = 245.404;
my $filecounter;
my $jtxfilename;
my $meanx;
my $meany;
my @meanxdif = ();
my @meanydif = ();
my $jtxcounter;
my @jtxformvalues = ();
my @differencex = ();
my @differencey = ();
my $sumxdif;
my $sumydif;
my @shiftedsnxlocation = ();
my @shiftedsnylocation = ();
my $snlocationfluxcounter = 0;
my @coordarray = ();
my $coordcounter;
my $distance;
my @fluxpersigma = ();
my @FWHM = ();
my $filename;

$jtxfilecounter = 0;
open registeredlist, "<fdrsub.list" or die $!;
while(<registeredlist>)
{
	#print "Hi there!\n";
	chomp;
	$filename = $_;
	$jtxfilename = $_ . ".jtxform.out";
	$coordfilename = $_ . ".fdr.coord";
	$meanx = 0;
	$meany = 0;
	$sumxdif = 0;
	$sumydif = 0;
	$jtxcounter = 0;
	@jtxformvalues = ();
	open jtxformout, "<", $jtxfilename or die $!;
	while(<jtxformout>)
	{
		if($_ !~ m/x1/)
		{
			chomp;
			@jtxformvalues = (@jtxformvalues, [split(/ +/)]);
			#print @jtxformvalues[$jtxcounter]->[2] . " " . @jtxformvalues[$jtxcounter]->[4] . "\n";
			$differencex[$jtxcounter] = @jtxformvalues[$jtxcounter]->[1] - @jtxformvalues[$jtxcounter]->[3];
			$differencey[$jtxcounter] = @jtxformvalues[$jtxcounter]->[2] - @jtxformvalues[$jtxcounter]->[4];
			print $differencex[$jtxcounter] . " " . $differencey[$jtxcounter] . "\n";
			$sumxdif += $differencex[$jtxcounter];
			$sumydif += $differencey[$jtxcounter];

			$jtxcounter++;
		}
	}
	#print $jtxcounter . " " . $sumxdif "\n";
	close(jtxformout);
	$meanxdif[$jtxfilecounter] = $sumxdif / $jtxcounter;
	$meanydif[$jtxfilecounter] = $sumydif / $jtxcounter;
	#print $meanxdif[$jtxfilecounter] . " " . $meanydif[$jtxfilecounter] . "\n";
	$shiftedsnxlocation[$jtxfilecounter] = $snxcoordbefore - $meanxdif[$jtxfilecounter];
	$shiftedsnylocation[$jtxfilecounter] = $snycoordbefore - $meanydif[$jtxfilecounter];

	open coordfile, ">", $coordfilename or die $!;
	print coordfile $shiftedsnxlocation[$jtxfilecounter] . " " . $shiftedsnylocation[$jtxfilecounter];
	close(coordfile);
	

close(registeredlist);


