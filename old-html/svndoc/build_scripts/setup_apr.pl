#!/usr/bin/perl
#
#	Apache �̃r���h�c���[���� apr-dll �� iconv �֘A�t�@�C����
#	�R�s�[����X�N���v�g
#

use File::Copy;
use File::Path;
$installdir = "C:/Program Files/Subversion";
$dst_bin    = "$installdir/bin";
$dst_iconv  = "$installdir/iconv";

#####################################
#  ���|��
####################################
if( -d $dst_bin ){
	@aprfiles = <"$dst_bin/libapr*.dll">;
	unlink @aprfiles;
	print "removing apr dll files\n";
	print join "\n", @aprfiles;
}
else{
	mkpath $dst_bin;
}

if( -d $dst_iconv ){
	@iconvfiles = (<"$dst_iconv/*.so">, <"$dst_iconv/*.pdb">);
	unlink @icovfiles;
	print "removing icov files\n";
	print join "\n", @iconvfiles;
}
else{
	mkpath $dst_iconv;
}

#####################################
#  apr dlls �R�s�[
####################################
push @aprdlls, <./srclib/apr/Release/*.dll>;
push @aprdlls, <./srclib/apr-iconv/Release/*.dll>;
push @aprdlls, <./srclib/apr-util/Release/*.dll>;
print "copying apr dll files\n";

foreach $file ( @aprdlls ){
	print "$file => $dst_bin\n";
	copy $file, "$dst_bin";
}

#####################################
#  iconv �R�s�[
####################################
$src_iconv = "./srclib/apr-iconv/Release/iconv";
@iconvfiles = (<$src_iconv/*.so>, <$src_iconv/*.pdb> );
print "copying icov files\n";

foreach $file ( @iconvfiles ){
	print "$file => $dst_iconv\n";
	copy $file, "$dst_iconv";
}
