/* 
This is example of mixing C and assembly (using MS Visual C)

this file demonstrates following:
- calling stdcall function defined in asm      (fasm_stdcall_avg)
- calling ccall function defined in asm        (fasm_ccall_avg)
 - accessing data defined in asm                (fasm_string)

compile with:
	cl /c c.c
link with:
	link c.obj asm.obj
*/

// declare things defined in assembly
unsigned int __stdcall fasm_stdcall_avg(unsigned int, unsigned int);
unsigned int __stdcall fasm_stdcall_avg2(unsigned int, unsigned int);
unsigned int fasm_ccall_avg(unsigned int, unsigned int);
unsigned int fasm_ccall_avg2(unsigned int, unsigned int);
extern char fasm_string[];

// define "c_int" variable
unsigned int c_int;

// define c_stdcall_display
int __stdcall c_stdcall_display(char* str, unsigned int num)
{
	printf("%s%08X\n",str,num);
	return 0;
}

// define c_ccall_display
int c_ccall_display(char* str, unsigned int num)
{
	printf("%s%08X\n",str,num);
	return 0;
}


void main()
{
	// access string defined in FASM
	puts(fasm_string);

	// call assembly procedures
	printf("Average of 1 and 5 is %u\n", fasm_stdcall_avg(1,5));
	printf("Average of 0 and 0 is %u\n", fasm_stdcall_avg2(0,0));
	printf("Average of 1 and 4294967295 is %u\n", fasm_ccall_avg(1,4294967295));
	printf("Average of 4294967295 and 4294967293 is %u\n", fasm_ccall_avg(4294967295, 4294967293));

	// call access_c(), which calls functions defined above
	c_int=10;
	access_c();
}
