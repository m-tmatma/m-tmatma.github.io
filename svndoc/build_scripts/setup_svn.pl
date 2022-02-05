#!/usr/bin/perl
#
#	Subversion のコンパイル用の作業ディレクトリから必要なファイルを
#	コピー & 名前変更してインストールするスクリプト
#

use File::Copy;
use File::Path;
$installdir = "C:/Program Files/Subversion";
$pythondir  = "C:/Python25";
$config     = "Release";

@mo_files = <$config/mo/*.mo>;
foreach $mo_file ( @mo_files ){
	my @tmp = split /\//, $mo_file;
	$lang = pop @tmp;
	$lang =~ s!\.mo$!!;

	my $targetdir = "$installdir/share/locale/$lang/LC_MESSAGES";
	my $mov_file = "$targetdir/subversion.mo";

	mkpath $targetdir;
	print "copy $mo_file => $mov_file\n";
	copy $mo_file, $mov_file;
}

my @exe_files;
my @exe_srcdirs = <./$config/subversion/*>;
foreach $exe_dir ( @exe_srcdirs ){
	if( -d $exe_dir && $exe_dir =~ /svn/ ){
		push @exe_files, <$exe_dir/*.exe>;
	}
}

@libsvn_dirs = <./$config/subversion/libsvn_*>;
foreach $libsvn_dir ( @libsvn_dirs ){
	push @exe_files, <$libsvn_dir/*.dll>;
}


foreach $exe_file ( @exe_files ){
	my $targetdir = "$installdir/bin";
	
	mkpath $targetdir;
	print "copy $exe_file => $targetdir\n";
	copy $exe_file, $targetdir;
}

# mkdir C:\Python24\Lib\site-packages\svn
# mkdir C:\Python24\Lib\site-packages\libsvn
# copy /Y subversion\bindings\swig\python\svn\*.py      C:\Python24\Lib\site-packages\svn
# copy /Y subversion\bindings\swig\python\*.py          C:\Python24\Lib\site-packages\libsvn
# copy /Y $config\subversion\bindings\swig\python\*.dll C:\Python24\Lib\site-packages\libsvn
@swig_svn    = <subversion/bindings/swig/python/svn/*.py>;
@swig_libsvn = <subversion/bindings/swig/python/*.py>;
@swig_dll    = <$config/subversion/bindings/swig/python/*.dll>;

push @swig_libsvn, <$config/subversion/bindings/swig/python/libsvn_swig_py/*.dll>;

################################################
# site-packages/svn へのコピー
################################################
foreach $py_file ( @swig_svn ){
	my $targetdir = "$pythondir/Lib/site-packages/svn";
	mkpath $targetdir;
	print "copy $py_file => $targetdir\n";
	copy $py_file, $targetdir;
}

################################################
# site-packages/libsvn へのコピー
################################################
foreach $py_file ( @swig_libsvn ){
	my $targetdir = "$pythondir/Lib/site-packages/libsvn";
	mkpath $targetdir;
	print "copy $py_file => $targetdir\n";
	copy $py_file, $targetdir;
}

################################################
# site-packages/libsvn へのコピー(dll => pyd)
################################################
foreach $dll_file ( @swig_dll ){
	my $targetdir = "$pythondir/Lib/site-packages/libsvn";
	my @tmp = split /\//, $dll_file;
	my $targetfile = pop @tmp;
	$targetfile =~ s/\.dll$/\.pyd/;
	mkpath $targetdir;
	print "copy $dll_file => $targetdir/$targetfile\n";
	copy $dll_file, "$targetdir/$targetfile";
}
