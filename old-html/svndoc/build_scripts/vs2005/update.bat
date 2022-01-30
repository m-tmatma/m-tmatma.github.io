call build.bat
perl setup_svn.pl
call davsvn.bat
svn log -r HEAD
