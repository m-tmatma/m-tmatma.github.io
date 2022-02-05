#!/usr/bin/perl

#   [1] REPOS-PATH   (the path to this repository)
#   [2] USER         (the authenticated user attempting to commit)
#   [3] CAPABILITIES (a comma-separated list of capabilities reported
#                     by the client; see note below)
#
# Note: The CAPABILITIES parameter is new in Subversion 1.5, and 1.5
# clients will typically report at least the "mergeinfo" capability.
# If there are other capabilities, then the list is comma-separated,
# e.g.: "mergeinfo,some-other-capability" (the order is undefined).
#
$repos = $ARGV[0];
$user  = $ARGV[1];
$capa  = $ARGV[2];

# CAPABILITIES �� ':' (�R����) �ŋ�؂�ꂽ���X�g�Ȃ̂�
# �R�������Z�p���[�^�Ƃ��ĕ�������B
@capa  = split /:/, $capa;

# �������邽�߂ɁA��x�n�b�V���ɓ���Ă���
foreach my $tmp ( @capa ){
	$capa{ $tmp }++;
}

# "mergeinfo" ���܂ނ��ǂ����Ŕ��f����
if( $capa{ "mergeinfo" } ){
	exit 0;
}
else{
	print STDERR "commit fail: you must use Subversion 1.5 or newer\n";
	exit 1;
}
