set APACHEDIR=..\common\httpd-2.2.4
set BDB_DIR=..\common\db4-win32\bin
set SSL_DIR=..\common\openssl-0.9.8e\out32dll
set I18N_DIR=..\common\svn-win32-libintl\bin
set SERF_DIR=..\common\serf
set SQLITE_DIR=..\common\sqlite3\bin

set RELEASE=.\Release\subversion\svn
set DEBUG=.\Debug\subversion\svn

mkdir %RELEASE%
mkdir %DEBUG%
del %RELEASE%\*.dll
del %DEBUG%\*.dll

copy %APACHEDIR%\srclib\apr\Release\lib*.dll        %RELEASE%
copy %APACHEDIR%\srclib\apr\Debug\lib*.dll          %RELEASE%
copy %APACHEDIR%\srclib\apr-iconv\Release\lib*.dll  %RELEASE%
copy %APACHEDIR%\srclib\apr-iconv\Debug\lib*.dll    %RELEASE%
copy %APACHEDIR%\srclib\apr-util\Release\lib*.dll   %RELEASE%
copy %APACHEDIR%\srclib\apr-util\Debug\lib*.dll     %RELEASE%

copy %APACHEDIR%\srclib\apr\Release\lib*.dll        %DEBUG%
copy %APACHEDIR%\srclib\apr\Debug\lib*.dll          %DEBUG%
copy %APACHEDIR%\srclib\apr-iconv\Release\lib*.dll  %DEBUG%
copy %APACHEDIR%\srclib\apr-iconv\Debug\lib*.dll    %DEBUG%
copy %APACHEDIR%\srclib\apr-util\Release\lib*.dll   %DEBUG%
copy %APACHEDIR%\srclib\apr-util\Debug\lib*.dll     %DEBUG%

copy %BDB_DIR%\*.dll     %RELEASE%
copy %BDB_DIR%\*.dll     %DEBUG%

copy %SSL_DIR%\*.dll     %RELEASE%
copy %SSL_DIR%\*.dll     %DEBUG%

copy %I18N_DIR%\*.dll    %RELEASE%
copy %I18N_DIR%\*.dll    %DEBUG%

copy %SQLITE_DIR%\*.dll    %RELEASE%
copy %SQLITE_DIR%\*.dll    %DEBUG%
