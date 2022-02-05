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
		if( $data =~ m!UA-49508988-1! )
		{
			$ua = 1;
		}
		if( $ua == 0 && $data =~ m!<noscript>! )
		{
			print OUT <<TAG;
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-49508988-1', 'asahi-net.or.jp');
  ga('send', 'pageview');

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
