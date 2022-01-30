set APACHEDIR=D:\Apache22
set HTTPD=%APACHEDIR%\bin\httpd.exe
set MOD_DAV_SVN_DIR=.\Release\subversion\mod_dav_svn

%HTTPD% -k stop
copy %MOD_DAV_SVN_DIR%\mod_dav_svn.so %APACHEDIR%\modules
%HTTPD% -k start
