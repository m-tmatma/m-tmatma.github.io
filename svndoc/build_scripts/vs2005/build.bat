perl config.pl
del Debug\subversion\libsvn_subr\opt.obj
del Release\subversion\libsvn_subr\opt.obj

call "C:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86

devenv subversion_vcnet.sln /build Release  /project __ALL__
devenv subversion_vcnet.sln /build Release  /project __SWIG_PYTHON__
