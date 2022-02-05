#!/usr/bin/perl

###############################################################################
#
#	check-ccmmit-changed.pl
#
#	svnlook changed を利用して意図していないファイル/ディレクトリのコミットを
#	拒否するスクリプト。pre-commit (pre-commit.bat) から呼び出すことが前提
#
#	pre-commit.bat の例
#		set REPOS=%1
#		set TXN=%2
#
#		set PATH=C:\Program Files\Subversion\bin
#		c:\Perl\bin\perl.exe %REPOS%\hooks\check-ccmmit-changed.pl %REPOS% %TXN%
#		exit %ERRORLEVEL%
#
#	pre-commit の例 (for UNIX)
#		#!/bin/sh
#		REPOS=%1
#		TXN=%2
#		
#		set PATH=/usr/bin
#		/usr/bin/perl $REPOS/hooks/check-ccmmit-changed.pl $REPOS $TXN || exit 1
#		exit 0
#
###############################################################################

# !!! 適宜書き換えて !!!
# svnlook の絶対パスを指定する
# または呼び出し側の pre-commit または pre-commit.bat で環境変数 PATH に
# svnlook のパスを設定しても OK
$SVNLOOK = "svnlook";

# pre-commit (pre-commit.bat) からの引数
$REPOS   = $ARGV[0];
$TXN     = $ARGV[1];

# debug オプション
$debug   = 0;

# svnlook のコマンドライン引数
$svnlook_cmd = "$SVNLOOK changed  -t $TXN $REPOS";

# svnlook を(パイプで)実行
open IN, "$svnlook_cmd |";

@svnlook_output = ();
$veto_files = 0;
while( $data = <IN> )
{
	push @svnlook_output, $data;

	#	svnlook changed の出力フォーマット
	#
	#	参考: http://svn.collab.net/repos/svn/trunk/subversion/svnlook/main.c : print_changed_tree
	#	参考: http://svn.apache.org/repos/asf/subversion/trunk/subversion/svnlook/main.c : print_changed_tree
	#
	#	XYZ filepath     (from node:rXXX)
	#
	#	X = "A", "D", "U", "_"
	#	Y = " ", "U"
	#	Z = " ", "+"
	#
	#	" " は "_" で表すとする
	#		1. A__ filepath
	#		2. A_+ filepath     (from copynode:rXXX)
	#		3. D__ filepath
	#		4. U__ filepath
	#		5. UU_ filepath
	#		6. _U_ filepath

	$file = $data;
	$file =~ s!^....!!;			# 先頭の4文字を消す
	$file =~ s!\(from .+\)!!;	# (from copynode:rXXX)を消す
	$file =~ s!\s+$!!;			# 末尾の空白を消す

	if( $data =~ /^D/ )
	{
		# ファイル or ディレクトリ削除は許可
		next;
	}

	# ファイルパスを元にコミットの可否を判断する
	if( !is_allowed_to_commit( $file ) )
	{
		print STDERR "We are NOT allowed to commit temporary files ($file)\n";
		$veto_files++;
	}
}
close IN;

if( $veto_files > 0 )
{
	print STDERR "You tried to commit $veto_files files or dirs which are NOT allowed to.\n";
	
	if( $debug )
	{
		print STDERR "svnlook output is\n";
		print STDERR @svnlook_output;
	}
	exit 1
}

exit 0;

############################################################################3
#
#	ファイルパスを元にコミットを許可するか拒否するか判断する関数
#
#	戻り値
#		1: コミットを許可する
#		0: コミットを拒否する
#
#	!!! 適宜書き換えて !!!
############################################################################3
sub is_allowed_to_commit
{
	my $file = shift;

	if( $file =~ /obj(fre|chk)_(\w+)/ )	# object dir check
	{
		return 0;
	}
	elsif( $file =~ /build(fre|chk)_(\w+)\.(log|err|wrn)/ )	# build log
	{
		return 0;
	}
	elsif( $file =~ /(\w+)\.(\w+)\.user$/ )	# build log
	{
		return 0;
	}
	elsif( $file =~ /_objects\.mac$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.ncb$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.opt$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.plg$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.suo$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.obj$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.res$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.exp$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.idb$/ )
	{
		return 0;
	}
	elsif( $file =~ /\.ilk$/ )
	{
		return 0;
	}
	elsif( $file =~ /mt\.dep$/ )
	{
		return 0;
	}
	elsif( $file =~ /(vc(\d+))\.pdb$/ )
	{
		return 0;
	}
	elsif( $file =~ /BuildLog\.htm$/ )
	{
		return 0;
	}
	return 1;
}
