#!/usr/bin/perl

$capa  = $ARGV[2];
if( $capa =~ /mergeinfo/ ){
	exit 0;
}
else{
	print STDERR "commit fail: you must use Subversion 1.5 or newer\n";
	exit 1;
}
