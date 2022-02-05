#!/usr/bin/perl

###############################################################################
#
#	check-ccmmit-changed.pl
#
#	svnlook changed �𗘗p���ĈӐ}���Ă��Ȃ��t�@�C��/�f�B���N�g���̃R�~�b�g��
#	���ۂ���X�N���v�g�Bpre-commit (pre-commit.bat) ����Ăяo�����Ƃ��O��
#
#	pre-commit.bat �̗�
#		set REPOS=%1
#		set TXN=%2
#
#		set PATH=C:\Program Files\Subversion\bin
#		c:\Perl\bin\perl.exe %REPOS%\hooks\check-ccmmit-changed.pl %REPOS% %TXN%
#		exit %ERRORLEVEL%
#
#	pre-commit �̗� (for UNIX)
#		#!/bin/sh
#		REPOS=%1
#		TXN=%2
#		
#		set PATH=/usr/bin
#		/usr/bin/perl $REPOS/hooks/check-ccmmit-changed.pl $REPOS $TXN || exit 1
#		exit 0
#
###############################################################################

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
$svnlook_cmd = "$SVNLOOK changed  -t $TXN $REPOS";

# svnlook ��(�p�C�v��)���s
open IN, "$svnlook_cmd |";

@svnlook_output = ();
$veto_files = 0;
while( $data = <IN> )
{
	push @svnlook_output, $data;

	#	svnlook changed �̏o�̓t�H�[�}�b�g
	#
	#	�Q�l: http://svn.collab.net/repos/svn/trunk/subversion/svnlook/main.c : print_changed_tree
	#	�Q�l: http://svn.apache.org/repos/asf/subversion/trunk/subversion/svnlook/main.c : print_changed_tree
	#
	#	XYZ filepath     (from node:rXXX)
	#
	#	X = "A", "D", "U", "_"
	#	Y = " ", "U"
	#	Z = " ", "+"
	#
	#	" " �� "_" �ŕ\���Ƃ���
	#		1. A__ filepath
	#		2. A_+ filepath     (from copynode:rXXX)
	#		3. D__ filepath
	#		4. U__ filepath
	#		5. UU_ filepath
	#		6. _U_ filepath

	$file = $data;
	$file =~ s!^....!!;			# �擪��4����������
	$file =~ s!\(from .+\)!!;	# (from copynode:rXXX)������
	$file =~ s!\s+$!!;			# �����̋󔒂�����

	if( $data =~ /^D/ )
	{
		# �t�@�C�� or �f�B���N�g���폜�͋���
		next;
	}

	# �t�@�C���p�X�����ɃR�~�b�g�̉ۂ𔻒f����
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
#	�t�@�C���p�X�����ɃR�~�b�g�������邩���ۂ��邩���f����֐�
#
#	�߂�l
#		1: �R�~�b�g��������
#		0: �R�~�b�g�����ۂ���
#
#	!!! �K�X���������� !!!
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
