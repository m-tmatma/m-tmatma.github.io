#!/usr/bin/perl

@deldirs = (
	"build\\win32\\msvc-dsp",
	"build\\win32\\vcnet-vcproj",
	"subversion_msvc.dsw",
	"subversion_vcnet.sln",
	"subversion\\svn_private_config.h",
);
@delfiles = <subversion\\bindings\\swig\\python\\*.c>;
unlink @delfiles;

foreach $delfile ( @deldirs ){
	if( -f $delfile or -d $delfile ){
		$cmd = "fast_rm $delfile";
		print "$cmd\n";
		system $cmd;
	}
}

$root = "../common";
%options = (
	"--disable-shared"   => "",
	"--with-sqlite"      => "$root/sqlite3.4",
	"--enable-ml"        => "",
	"--enable-nls"       => "",
	"--with-openssl"     => "$root/openssl-0.9.8e",
	"--with-libintl"     => "$root/svn-win32-libintl",
	"--with-swig"        => "C:/swigwin-1.3.31",
	"--with-neon"        => "$root/neon",
	"--with-serf"        => "$root/serf",
	"--with-berkeley-db" => "$root/db4-win32",
	"--with-zlib"        => "$root/zlib",
	"--with-httpd"       => "$root/httpd-2.2.6",
);

$options = "-t dsp";
while ( ($key, $value) = each(%options) ) {
	if( $value ){
		$options = "$options $key=$value";
	}
	else{
		$options = "$options $key";
	}
}
$options =~ s!/!\\!g;
$cmd = "gen-make.py $options";
print "$cmd\n";
system $cmd;
