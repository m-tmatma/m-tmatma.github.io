msdev subversion_msvc.dsw /MAKE "locale - Win32 Release"
perl setup_svn.pl
svn log -r HEAD
