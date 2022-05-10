#include<unistd.h>

// Useless piece of code, used to discover sys_read system call id: you can find it at 0x20866 ;)

int main() {
	int i;
	read(0, (void*) &i, 1);
}
