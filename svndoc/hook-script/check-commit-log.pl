#!/usr/bin/perl

###############################################################################
#
#	check-commit-log.pl
#
#	svnlook log を利用して Redmine との連携キーワードを含まないコミットを
#	拒否するスクリプト。pre-commit (pre-commit.bat) から呼び出すことが前提
#
#	pre-commit.bat の例
#		set REPOS=%1
#		set TXN=%2
#
#		set PATH=C:\Program Files\Subversion\bin
#		c:\Perl\bin\perl.exe %REPOS%\hooks\check-commit-log.pl %REPOS% %TXN%
#		exit %ERRORLEVEL%
#
#	pre-commit の例 (for UNIX)
#		#!/bin/sh
#		REPOS=%1
#		TXN=%2
#		
#		set PATH=/usr/bin
#		/usr/bin/perl $REPOS/hooks/check-commit-log.pl $REPOS $TXN || exit 1
#		exit 0
#
###############################################################################
use FindBin;	# スクリプト名を参照するためのモジュール

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
$svnlook_cmd = "$SVNLOOK log  -t $TXN $REPOS";

# svnlook を(パイプで)実行
open IN, "$svnlook_cmd |";

my @svnlook_output = <IN>;
close IN;

# コミットログを連結して 1 つの文字列にする
my $commit_log = join "", @svnlook_output;

if( !is_commit_log_valid( $commit_log) )
{
	print STDERR "$FindBin::Script: Your commit is blocked because the commit log has no valid redmine keyword.\n";
	exit 1;
}

exit 0;

############################################################################3
#
#	コミットログを元にコミットを許可するか拒否するか判断する関数
#
#	戻り値
#		1: コミットを許可する
#		0: コミットを拒否する
#
#	!!! 適宜書き換えて !!!
#
#	参考
#		http://www.redmine.org/wiki/1/RedmineSettings#Referencing-issues-in-commit-messages
#		http://redmine.jp/tech_note/subversion/
############################################################################3
sub is_commit_log_valid
{
	my $commit_log  = shift;
	
	# Redmine のキーワードがふくれているかチェックする
	unless( $commit_log =~ /(^|\b)refs #(\d+)($|\b)/ )
	{
		# Redmine のキーワードが含まれているけど不正な場合に
		# チェックしてエラーの内容をユーザーに知らせる
		if( $commit_log =~ /refs #(\d+)/ )
		{
			print STDERR "$FindBin::Script: You must divide refs keyword by word separators (i.e space)\n";
		}
		elsif( $commit_log =~ /#(\d+)/ )
		{
			print STDERR "$FindBin::Script: You must specify refs keyword before #$1\n";
		}
		print STDERR "$FindBin::Script: Example of a working commit message\n";
		print STDERR "$FindBin::Script:  refs #2345\n";
		print STDERR "$FindBin::Script:  ...\n";
		print STDERR "$FindBin::Script:  ...\n";
		print STDERR "$FindBin::Script: \n";
		print STDERR "$FindBin::Script: See http://www.redmine.org/wiki/1/RedmineSettings#Referencing-issues-in-commit-messages\n";
		print STDERR "$FindBin::Script: or http://redmine.jp/tech_note/subversion/ for detail.\n";
		return 0;
	}

	return 1;
}
