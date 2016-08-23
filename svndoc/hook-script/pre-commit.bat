set REPOS=%1
set TXN=%2

c:\Perl\bin\perl.exe %REPOS%\hooks\check-ccmmit-changed.pl %REPOS% %TXN%
exit %ERRORLEVEL%
