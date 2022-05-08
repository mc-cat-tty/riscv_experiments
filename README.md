## Setting up the environment

1. Get QEMU-riscv64: `pacman -S qemu-arch-extra`
2. Compile riscv-gnu-toolchain
	1. `git clone https://github.com/riscv-collab/riscv-gnu-toolchain && cd riscv-gnu-toolchain`
	2. Install dependencies: `sudo pacman -Syyu autoconf automake curl python3 libmpc mpfr gmp gawk base-devel bison flex texinfo gperf libtool patchutils bc zlib expat`
	3. `./configure --prefix=/opt/riscv`
	4. `make && make linux`
	5. add `export PATH="/opt/riscv/bin/:$PATH"` to the file .zshrc or .bashrc

### Test your environment
To be sure your dev-env is ready try to compile _hello\_world.c_ and run it through qemu-riscv64:
```bash
riscv64-unknown-elf-gcc -static -Wall --pedantic hello_world.c
qemu-riscv64 a.out
```

For more details see: [https://saveriomiroddi.github.io/Quick-riscv-cross-compilation-and-emulation/](https://saveriomiroddi.github.io/Quick-riscv-cross-compilation-and-emulation/)
