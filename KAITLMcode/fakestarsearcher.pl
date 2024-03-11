#!/usr/bin/perl
my @magarray = ();
my $target;
my $filename;
my @array = ();
my $counter = 0;
my $distance;
my $outputlimits;
my @addstararray = ();
my @fakestarxcoords = ();
my @fakestarycoords = ();
my $addstarcounter = 0;
my @starfoundlist = ();
my $starfoundratio;
#my $snxcoord = 246;
#my $snycoord = 297;
my $i;
my $magvaluue;
my $fluxvalue;
my $fluxvaluerefpoint;
my $computedmagvalue;
my $difmagvalues;
my $fluxvaluerefpointtotal;
my $fluxvaluerefpointavg;



open xycoordslist, "<sn2010jl.addstar" or die $!;
while(<xycoordslist>)
{
	if($_ !~ m/#/)
	{
		chomp;
		@addstararray = (@addstararray, [split(/ +/)]);
		$fakestarxcoords[$addstarcounter] = @addstararray[$addstarcounter]->[1];
		$fakestarycoords[$addstarcounter] = @addstararray[$addstarcounter]->[2];
		$addstarcounter++;
	}
}
close(xycoordslist);

$target = $ARGV[0];

open Inputfakestarmagslist, "<fakestarmags.list" or die $!;
open Outputlist, ">>limitingmagnitude.list" or die $!;

while(<Inputfakestarmagslist>)
{
	chomp;
	@magarray = split(/\./);

	$filename = $target . ".addstar.$magarray[0].$magarray[1].coo";
	$magvalue = "$magarray[0].$magarray[1]";

	open Inputcoordinates, "<", $filename or die $!;
	
	if($magvalue == "18.0")
	{
		@array = ();
		$counter = 0;
		while(<Inputcoordinates>)
		{
			if($_ !~ m/#/)
			{
				chomp;
				@array = (@array, [split(/ +/)]);
			
				for($i=0;$i<$addstarcounter;$i++)
				{
					$distance = (($fakestarxcoords[$i] - @array[$counter]->[1])**2 + ($fakestarycoords[$i] - @array[$counter]->[2])**2)** 0.5;
					$fluxvalue = @array[$counter]->[4];
					if($distance < 3)
					{
						$fluxvaluerefpoint[$i] = $fluxvalue;
						$starfoundlist[$i] = 1;
					}
				}
				$counter++;
			}
		}
		close(Inputcoordinates);

		$starfoundtotal = 0;
		for($i=0;$i<$addstarcounter;$i++)
		{
			$starfoundtotal += $starfoundlist[$i];
			$fluxvaluerefpointtotal += $fluxvaluerefpoint[$i];
			#print $fluxvaluerefpoint[$i] . "\n";
		}

		#print $starfoundtotal . "\n";
		$starfoundratio = $starfoundtotal / $addstarcounter;

		if ($starfoundratio != 1)
		{
			print "Did not find all of the fake stars for the reference point for " . $filename .  "\n";
		}

		$fluxvaluerefpointavg = $fluxvaluerefpointtotal / $starfoundtotal;
		#print $fluxvaluerefpointavg . "\n";
	}

	@array = ();
	$counter = 0;
	@starfoundlist = ();
	while(<Inputcoordinates>)
	{
		if($_ !~ m/#/)
		{
			chomp;
			@array = (@array, [split(/ +/)]);
			
			for($i=0;$i<$addstarcounter;$i++)
			{
				$distance = (($fakestarxcoords[$i] - @array[$counter]->[1])**2 + ($fakestarycoords[$i] - @array[$counter]->[2])**2)** 0.5;
				$fluxvalue = @array[$counter]->[4];
				if($distance < 3)
				{
					if (($fluxvalue > 0) && ($fluxvaluerefpointavg > 0))
					{
						$computedmagvalue = 18 - 2.5 * log($fluxvalue/$fluxvaluerefpointavg) / log(10);
					}
					else
					{
						$computedmagvalue = 500;
					}

					$difmagvalues = abs($magvalue - $computedmagvalue);
					if($difmagvalues < 0.36191206825)
						{
							#print "Fake star " . $i . " found for " . "$magarray[0].$magarray[1]\n";
							$starfoundlist[$i] = 1;
						}
					#$starfoundtotal++;
				}
			}
			$counter++;
		}
	}
	close(Inputcoordinates);

	$starfoundtotal = 0;
	for($i=0;$i<$addstarcounter;$i++)
	{
		$starfoundtotal += $starfoundlist[$i];
	}

	#print $starfoundtotal . "\n";
	$starfoundratio = $starfoundtotal / $addstarcounter;

	if ($starfoundratio >= 0.5)
	{
		$outputlimits = "$magarray[0].$magarray[1] " . $outputlimits;
	}

}

print Outputlist "$ARGV[0] $outputlimits \n" ;

close(Inputfakestarmagslist);
close(Outputlist);


