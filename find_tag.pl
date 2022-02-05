######################################################
#
#	アクセス解析用タグがない html を探す
#
######################################################

use File::Find;
use File::Copy;

find({ wanted => \&process, no_chdir => 1 }, '.');

sub process
{
	my $path = $File::Find::name;
	if( $path =~ /(\.html|\.htm)$/ ){
#		print "$path\n";
		find_no_analyze( $path );
	}
}

sub find_no_analyze
{
	my $count = 0;
	my $path = shift;
	open IN,  $path;
	while( $data = <IN> ){
		chomp;
		if( $data =~ /analyzer5\.fc2\.com/ )
		{
			$count++;
		}
	}
	close IN;
	if( $count == 0 )
	{
		print "$path\n"
	}
}
