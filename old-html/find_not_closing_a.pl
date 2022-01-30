######################################################
#
#	<a ref> ƒ^ƒO‚Å " ‚ª•Â‚¶‚Ä‚¢‚È‚¢‰ÓŠ‚ð’T‚·
#
######################################################

use File::Find;
use File::Copy;

find({ wanted => \&process, no_chdir => 1 }, '.');

sub process
{
	my $path = $File::Find::name;
	if( $path =~ /(\.html|\.htm)$/ ){
		find_no_analyze( $path );
	}
}

sub find_no_analyze
{
	my $line = 0;
	my $path = shift;
	open IN,  $path;
	while( $data = <IN> )
	{
		$line++;
		if ($data =~ m!<a href="([^"]+)>! )
		{
			printf "$path($line): $data";
		}
	}
	close IN;
}
