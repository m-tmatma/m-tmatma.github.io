######################################################
#
#	<a ref> タグで " が閉じていない箇所を探す
#
######################################################

use File::Find;
use File::Copy;

find({ wanted => \&process, no_chdir => 1 }, '.');

my $sitemap = "sitemap.html";
open OUT, ">$sitemap";
print OUT "<html>\n";
print OUT "<meta http-equiv=\"Content-Language\" content=\"ja\" />\n";
print OUT "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n";
print OUT "<title>サイトマップ</title>\n";
print OUT "<body>\n";
print OUT "<ul>\n";
foreach $array ( @{ $toc } )
{
	my $path  = @$array[0];
	my $title = @$array[1];
	#print "$path: $title\n";
	printf OUT "<li><a href=\"$path\">$title</a></li>\n";
}
print OUT "</ul>\n";
print OUT "</body>\n";
print OUT "</html>\n";
close OUT;

sub process
{
	my $path = $File::Find::name;
	if( $path =~ /(\.html|\.htm)$/ ){
		find_no_analyze( $path );
	}
}

sub find_no_analyze
{
	my $count = 0;
	my $path = shift;
	my $title = "";
	
	if( $path =~ /sitemap\.html$/ )
	{
		return;
	}

	open IN,  $path;
	while( $data = <IN> )
	{
		if( $data =~ m!<title>(.*)</title>! )
		{
			$title = $1;
			#print "$path: $title\n";
			last;
		}
	}
	close IN;
	
	push @{ $toc }, [ $path, $title ];
}
