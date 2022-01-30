rm Debug\subversion\libsvn_subr\opt.obj
rm Release\subversion\libsvn_subr\opt.obj
msdev subversion_msvc.dsw /MAKE "__ALL__ - Win32 Release"   
msdev subversion_msvc.dsw /MAKE "__SWIG_PYTHON__ - Win32 Release" 
