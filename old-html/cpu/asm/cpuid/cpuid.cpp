#include <stdio.h>
#include <string.h>
#include <intrin.h>

extern "C"
void my_cpuid(
   int CPUInfo[4],
   int InfoType
)
{
	__cpuid( CPUInfo, InfoType );
}
