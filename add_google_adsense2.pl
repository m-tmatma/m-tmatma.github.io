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
	my $out = "$path.tmp";
	my $ua = 0;
	
	open IN,  $path;
	open OUT, ">$out";
	while( $data = <IN> ){
		chomp $data;
		if( $data =~ m!adsbygoogle! )
		{
			$ua = 1;
		}
		if( $ua == 0 && $data =~ m!<noscript>! )
		{
			print OUT <<TAG;
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- adv -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-8722759789158430"
     data-ad-slot="8544576304"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>
TAG
		}
		print OUT $data, "\n";
	}
	close IN;
	close OUT;
	unlink $path;
	move $out, $path;
}
