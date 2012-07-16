# Batch geocode using the Google Maps API
use Google::GeoCoder::Smart;
use Time::localtime;
$geo = Google::GeoCoder::Smart->new();
$tm = localtime;

# reading inputs from a file 
open (ADDFILE,'<addressfile.txt');

# change CRLF for windows
$counter = 1;
while(<ADDFILE>){
	chomp;

	$filename = "resfile".$tm->mday."-".$tm->mon.".txt";
	open (RESFILE,">>$filename");
	
	# read line from file 
	my ($id,$add,$city,$state,$zip) = split (",");
	my ($resultnum, $error, @results, $returncontent) = $geo->geocode("address" => $add, "city"=> $city, "state"=> $state, "zip"=> $zip);
	$lat = $results[0]{geometry}{location}{lat};
	$lng = $results[0]{geometry}{location}{lng};
		
	if($lat && $lng) {
	print RESFILE "$id,$add,$city,$state,$zip,$lat,$lng\n";
	}
	else
	{ print RESFILE "$id,$add,$city,$state,$zip,ERR,$error\n"; 
	}
	$counter++;
	sleep(2);
	if($counter %2400 == 0) {
		close (RESFILE);
		sleep (24*60*60*1000); 
	}
}
close (ADDFILE);
