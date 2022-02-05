#!/usr/bin/perl

###############################################################################
#
#	check-commit-log.pl
#
#	svnlook log �𗘗p���� Redmine �Ƃ̘A�g�L�[���[�h���܂܂Ȃ��R�~�b�g��
#	���ۂ���X�N���v�g�Bpre-commit (pre-commit.bat) ����Ăяo�����Ƃ��O��
#
#	pre-commit.bat �̗�
#		set REPOS=%1
#		set TXN=%2
#
#		set PATH=C:\Program Files\Subversion\bin
#		c:\Perl\bin\perl.exe %REPOS%\hooks\check-commit-log.pl %REPOS% %TXN%
#		exit %ERRORLEVEL%
#
#	pre-commit �̗� (for UNIX)
#		#!/bin/sh
#		REPOS=%1
#		TXN=%2
#		
#		set PATH=/usr/bin
#		/usr/bin/perl $REPOS/hooks/check-commit-log.pl $REPOS $TXN || exit 1
#		exit 0
#
###############################################################################
use FindBin;	# �X�N���v�g�����Q�Ƃ��邽�߂̃��W���[��

# !!! �K�X���������� !!!
# svnlook �̐�΃p�X���w�肷��
# �܂��͌Ăяo������ pre-commit �܂��� pre-commit.bat �Ŋ��ϐ� PATH ��
# svnlook �̃p�X��ݒ肵�Ă� OK
$SVNLOOK = "svnlook";

# pre-commit (pre-commit.bat) ����̈���
$REPOS   = $ARGV[0];
$TXN     = $ARGV[1];

# debug �I�v�V����
$debug   = 0;

# svnlook �̃R�}���h���C������
$svnlook_cmd = "$SVNLOOK log  -t $TXN $REPOS";

# svnlook ��(�p�C�v��)���s
open IN, "$svnlook_cmd |";

my @svnlook_output = <IN>;
close IN;

# �R�~�b�g���O��A������ 1 �̕�����ɂ���
my $commit_log = join "", @svnlook_output;

if( !is_commit_log_valid( $commit_log) )
{
	print STDERR "$FindBin::Script: Your commit is blocked because the commit log has no valid redmine keyword.\n";
	exit 1;
}

exit 0;

############################################################################3
#
#	�R�~�b�g���O�����ɃR�~�b�g�������邩���ۂ��邩���f����֐�
#
#	�߂�l
#		1: �R�~�b�g��������
#		0: �R�~�b�g�����ۂ���
#
#	!!! �K�X���������� !!!
#
#	�Q�l
#		http://www.redmine.org/wiki/1/RedmineSettings#Referencing-issues-in-commit-messages
#		http://redmine.jp/tech_note/subversion/
############################################################################3
sub is_commit_log_valid
{
	my $commit_log  = shift;
	
	# Redmine �̃L�[���[�h���ӂ���Ă��邩�`�F�b�N����
	unless( $commit_log =~ /(^|\b)refs #(\d+)($|\b)/ )
	{
		# Redmine �̃L�[���[�h���܂܂�Ă��邯�Ǖs���ȏꍇ��
		# �`�F�b�N���ăG���[�̓��e�����[�U�[�ɒm�点��
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
