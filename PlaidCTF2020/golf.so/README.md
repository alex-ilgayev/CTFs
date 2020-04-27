# golf.so Writeup

## Problem Details

[golf.so.pwni.ng](http://golf.so.pwni.ng/)

## Solution

The linked site contains some leaderboard table with the ability to upload new solutions:

![](https://i.imgur.com/cNrhzC5.png)

When we try to upload we get the following message:

![](https://i.imgur.com/sBGKwLg.png)

Means we must create shared object which should run `execve` upon loading, and be small enough.

Lets start working.

### Sources

- [https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html) - great tutorial minimizing 32 bit linux executable.
- [https://stackoverflow.com/questions/53382589/smallest-executable-program-x86-64](https://stackoverflow.com/questions/53382589/smallest-executable-program-x86-64) - good exmaple porting the previous tutorial to 64 bit.
- [https://github.com/elemeta/elfloader](https://github.com/elemeta/elfloader) - Linux loader wasn't informative about it's issues, so I used external small loader to debug the ELF.
- [http://osr507doc.sco.com/en/topics/ELF_dynam_section.html](http://osr507doc.sco.com/en/topics/ELF_dynam_section.html) - Greate documentation of the dynamic section.

### Naive Try - Using GCC

First of all what is ELF ?

**Executable and Linkable Format** is a common standard in Unix environment which includes the following:

- Executable files (for example `/bin/bash`).
- Object code (for example `.o` file created by a compiler).
- Shared libraries (equivalent to `.dll` files).
- Core dumps.

The reason we use shared libraries  is mainly to reduce amount of code and data of the executables, and allow sharing common resources between multiple executables. Best example is the common `libc` shared library.

So lets compile a simple shared library which runs execve:

```c
int main() {
    execve("/bin/sh", 0, 0);
    return 0;
}
```

```bash
alex@ubuntu:~/Desktop/writeup$ LD_PRELOAD=./sample_gcc /bin/true
```

Nothing happens.

Apparently the Linux loader will not run anything (unlike Windows dllmain) unless it was commanded to with special annotation:

```c
__attribute__((constructor)) main() {
    execve("/bin/sh", 0, 0);
}
```

```bash
alex@ubuntu:~/Desktop/writeup$ LD_PRELOAD=./sample_gcc /bin/true
$ whoami
alex
alex@ubuntu:~/Desktop/writeup$ wc -c sample_gcc
7904 sample_gcc
```

Now it works, but the file is too big.

### Compiling ELF in NASM

I searched the web for template of a minimized ELF file so I can use NASM - a popular assembler and disassembler for Linux. So I used the following template:

```wasm
bits 64
            org 0x08048000

ehdr:                                           ; Elf64_Ehdr
            db  0x7F, "ELF", 2, 1, 1, 0         ;   e_ident
    times 8 db  0
            dw  2                               ;   e_type
            dw  62                              ;   e_machine
            dd  1                               ;   e_version
            dq  _start                          ;   e_entry
            dq  phdr - $$                       ;   e_phoff
            dq  0                               ;   e_shoff
            dd  0                               ;   e_flags
            dw  ehdrsize                        ;   e_ehsize
            dw  phdrsize                        ;   e_phentsize
            dw  1                               ;   e_phnum
            dw  0                               ;   e_shentsize
            dw  0                               ;   e_shnum
            dw  0                               ;   e_shstrndx

ehdrsize    equ $ - ehdr

phdr:                                           ; Elf64_Phdr
            dd  1                               ;   p_type
            dd  5                               ;   p_flags
            dq  0                               ;   p_offset
            dq  $$                              ;   p_vaddr
            dq  $$                              ;   p_paddr
            dq  filesize                        ;   p_filesz
            dq  filesize                        ;   p_memsz
            dq  0x1000                          ;   p_align

phdrsize    equ     $ - phdr

_start:
    xor eax, eax
    mul esi
    push rax
    mov rdi, "/bin//sh"
    push rdi
    mov rdi, rsp
    mov al, 59
    syscall

filesize      equ     $ - $$
```

We can compile it with NASM and run it:

```bash
alex@ubuntu:~/Desktop/writeup$ nasm -f bin -o try2 try2.asm
alex@ubuntu:~/Desktop/writeup$ ./try2
bash: ./try2: Permission denied
alex@ubuntu:~/Desktop/writeup$ chmod 777 try2
alex@ubuntu:~/Desktop/writeup$ ./try2
$
alex@ubuntu:~/Desktop/writeup$ wc -c try2
143 try2
```

We can observe the ELF using `readelf` command:

```bash
alex@ubuntu:~/Desktop/writeup$ readelf -h try2
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x8048078
  Start of program headers:          64 (bytes into file)
  Start of section headers:          0 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         1
  Size of section headers:           0 (bytes)
  Number of section headers:         0
  Section header string table index: 0
```

So lets analyze the assembly file:

- `bits 64` - 64 bit architecture
- `org 0x08048000` - Sets base address.
- `ehdr` - Defines ELF header. It is a must for every ELF file. We will soon see that not all the fields are mendatory.
    - `e_shoff` - Value for section header table is zero. This means the file has no sections like `.text`, `.data`, `.reloc` and more.
    - `e_phnum` - equals to 1. This means we have one program header.
    - A popular misconception is that executable must have sections. Sections are created by the compiler only for organizing the file and helping the loader to map each section to the appripriate memory region (R/W/X).
- `phdr` - The only program header in file.
    - `p_type` - Equals to 1. We can see using `readelf` it is of `LOAD` type.

    ```bash
    alex@ubuntu:~/Desktop/writeup$ readelf -l try2

    Elf file type is EXEC (Executable file)
    Entry point 0x8048078
    There is 1 program header, starting at offset 64

    Program Headers:
      Type           Offset             VirtAddr           PhysAddr
                     FileSiz            MemSiz              Flags  Align
      LOAD           0x0000000000000000 0x0000000008048000 0x0000000008048000
                     0x000000000000008f 0x000000000000008f  R E    0x1000
    ```

- `_start` - This symbol will be run upon file execution. In our case is contains shellcode running `execve`.

Now lets fix the file so it will be defined as shared object and not as executable:

- we change `dw  2                               ;   e_type` into `dw  3`.

```bash
alex@ubuntu:~/Desktop/writeup$ nasm -f bin -o try2 try2.asm 
alex@ubuntu:~/Desktop/writeup$ file try2
try2: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), statically linked, corrupted section header size
alex@ubuntu:~/Desktop/writeup$ LD_PRELOAD=./try2 /bin/true
ERROR: ld.so: object './try2' from LD_PRELOAD cannot be preloaded (object file has no dynamic section): ignored.
```

So we can see the file is indeed `shared object` but when we try to load it we receive `object file has no dynamic section`. Now the fun part begins.

### Creating Dynamic Program Header

According to [http://man7.org/linux/man-pages/man5/elf.5.html](http://man7.org/linux/man-pages/man5/elf.5.html):

> PT_DYNAMIC
The array element specifies dynamic linking information.

Not helping. Lets open in IDA the first GCC compiled version and dissect it.

**Program Header for the Dynamic data:**

![](https://i.imgur.com/zcfC2Yh.png)

It's `Virtual Address` field points to mapped address which contains more information about dynamic linking.

**Dynamic Linking Struct:**

![](https://i.imgur.com/qV6j1vX.png)

Digging into [http://osr507doc.sco.com/en/topics/ELF_dynam_section.html](http://osr507doc.sco.com/en/topics/ELF_dynam_section.html) led me into the next information:

- Each entry has 16 bytes size -
    - `dq code`
    - `dq value/ptr`
- `DT_NEEDED` - Linking to dependable libc. the value is index at string table.
- `DT_INIT` - Virtual address  to function which should run on loading.
- `DT_GNU_HASH` - Not sure about it's meaning. Because it was a must for a proper loading, I copied the values form this executable.
- `DT_STRTAB` - String table pointer. Contains important strings for loading and linking

![](https://i.imgur.com/tBc6B3Y.png)

- `DT_SYMTAB` - Symbol table pointer.

![](https://i.imgur.com/COiM6fs.png)

- `DT_STRSZ` - String table size.
- `DT_SYMENT` - Symbol table entry size.
- `DT_NULL` - Ending field.
- Rest weren't important for the challenge.

Using the attached sources, mandatory fields are: `DT_NULL`, `DT_HASH`, `DT_STRTAB`, `DT_SYMTAB`, `DT_STRSZ`, `ST_SYMENT`.

So lets create a custom dynamic section/table (`try3.asm`):

```wasm
bits 64
            org 0x08048000

ehdr:                                           ; Elf64_Ehdr
            db  0x7F, "ELF", 2, 1, 1, 0         ;   e_ident
    times 8 db  0
            dw  3                               ;   e_type
            dw  62                              ;   e_machine
            dd  1                               ;   e_version
            dq  _start                          ;   e_entry
            dq  0x40                            ;   e_phoff
            dq  0                               ;   e_shoff
            dd  0                               ;   e_flags
            dw  0x40                            ;   e_ehsize
            dw  0x38                            ;   e_phentsize
            dw  2                               ;   e_phnum
            dw  0                               ;   e_shentsize
            dw  0                               ;   e_shnum
            dw  0                               ;   e_shstrndx

phdr_load:                                           ; Elf64_Phdr
            dd  1                               ;   p_type
            dd  7                               ;   p_flags
            dq  0                               ;   p_offset
            dq  $$                              ;   p_vaddr
            dq  $$                              ;   p_paddr
            dq  filesize                        ;   p_filesz
            dq  filesize                        ;   p_memsz
            dq  0x1000                          ;   p_align

phdr_dyn:                                           ; Elf64_Phdr
            dd  2                               ;   p_type
            dd  6                               ;   p_flags
            dq  dyn_offset                      ;   p_offset
            dq  _dyn                            ;   p_vaddr
            dq  _dyn                            ;   p_paddr
            dq  dyn_size                        ;   p_filesz
            dq  dyn_size                        ;   p_memsz
            dq  0x8                          ;   p_align

_start:
    xor eax, eax
    mul esi
    push rax
    mov rdi, "/bin//sh"
    push rdi
    mov rdi, rsp
    mov al, 59
    syscall

dyn_offset equ $ - $$

_dyn:
    dq 6FFFFEF5h, _gnu_hash     ; DT_GNU_HASH
    dq 5, 0                     ; DT_STRTAB
    dq 6, 0                     ; DT_SYMTAB
    dq 0Ah, 0h                 ; DT_STRSZ
    dq 0Bh, 0h                 ; DT_SYMENT
    dq 0Ch, _start              ; DT_INIT
    dq 0,0

dyn_size    equ $ - _dyn

_gnu_hash:
    dd 1
    dd 1
    dd 1
    dd 0
    dq 0
    dd 0
    dd 0

filesize      equ     $ - ehdr
```

When we run it we get:

```bash
alex@ubuntu:~/Desktop/writeup$ LD_PRELOAD=./try3 /bin/true
$ 
alex@ubuntu:~/Desktop/writeup$ wc -c try3
343 try3
```

Great Progression !

In order to get the first flag, we need to be below 300.

Playing a bit with the assembly we can see `DT_GNU_HASH` isn't really mandatory, and can be removed.

This will give us:

```bash
alex@ubuntu:~/Desktop/writeup$ wc -c try3
295 try3
```

And the first flag:

![](https://i.imgur.com/4N29Vvw.png)

### Reducing to the Minimum

Lets try to find more unnecessary dynamic fields. 

We can remove `DT_SYMENT` and `DT_STRSZ`, but anything beyond that will give us SegFault.

Next effort will be finding unused fields inside program header, and elf header.

I iterated all the fields to find all the unused one. I also changed the the shellcode:

```wasm
bits 64
            org 0x08048000

ehdr:                                           ; Elf64_Ehdr
            db  0x7F, "ELF", 2, 1, 1, 0         ;   e_ident
    times 8 db  0
            dw  3                               ;   e_type
            dw  62                              ;   e_machine
            dd  1                               ;   e_version
            dq  _start                          ;   e_entry
            dq  0x40                            ;   e_phoff
            times 12 db 9   ; FREE SPACE
            dw  0x40                            ;   e_ehsize
            dw  0x38                            ;   e_phentsize
            dw  2                               ;   e_phnum
            times 6 db 9    ; FREE SPACE

phdr_load:                                           ; Elf64_Phdr
            dd  1                               ;   p_type
            dd  7                               ;   p_flags
            dq  0                               ;   p_offset
            dq  $$                              ;   p_vaddr
            times 16 db 9   ; FREE SPACE
            dq  filesize                        ;   p_memsz
            dq  0x1000                          ;   p_align

phdr_dyn:                                           ; Elf64_Phdr
            dd  2                               ;   p_type
            dd  6                               ;   p_flags
            dq  dyn_offset                      ;   p_offset
            dq  _dyn                            ;   p_vaddr
            times 32 db 9   ; FREE SPACES

_start:
    xor eax, eax
    mov rbx, 0xFF978CD091969DD1
    neg rbx
    push rbx
    push rsp
    pop rdi
    cdq
    push rdx
    push rdi
    push rsp
    pop rsi
    mov al, 0x3b
    syscall

dyn_offset equ $ - $$

_dyn:
    dq 5, 0                     ; DT_STRTAB
    dq 6, 0                     ; DT_SYMTAB
    dq 0Ch, _start              ; DT_INIT
    dq 0,0

dyn_size    equ $ - _dyn

filesize      equ     $ - ehdr
```

When we assemble the shellcode, we can split it, and use `jmp short` between the parts (2 byte instruction).

```wasm
part 1 - 10 bytes
48 bb d1 9d 96 91 d0    movabs rbx,0xff978cd091969dd1
8c 97 ff

part 2 - 3 bytes
48 f7 db                neg    rbx

part 3 - 14 bytes
31 c0                   xor    eax,eax
53                      push   rbx
54                      push   rsp
5f                      pop    rdi
99                      cdq
52                      push   rdx
57                      push   rdi
54                      push   rsp
5e                      pop    rsi
b0 3b                   mov    al,0x3b
0f 05                   syscall
```

So lets insert the shellcode into the spaces, and the dynamic table into the last 32 bytes space.

Final code (`try4.asm`):

```wasm
bits 64
            org 0x08048000

ehdr:                                           ; Elf64_Ehdr
            db  0x7F, "ELF", 2, 1, 1, 0         ;   e_ident
    times 8 db  0
            dw  3                               ;   e_type
            dw  62                              ;   e_machine
            dd  1                               ;   e_version
            dq  _start                          ;   e_entry
            dq  pht_start                       ;   e_phoff
    ; part 1
    _start: 
            mov rbx, 0xFF978CD091969DD1
            jmp part_2
            dw  0x40                            ;   e_ehsize
            dw  0x38                            ;   e_phentsize
            dw  2                               ;   e_phnum
    part_2:
            neg rbx
            jmp part_3

pht_start equ $ - $$

phdr_load:                                           ; Elf64_Phdr
            dd  1                               ;   p_type
            dd  7                               ;   p_flags
            dq  0                               ;   p_offset
            dq  $$                              ;   p_vaddr
    part_3:
            xor eax, eax
            push rbx
            push rsp
            pop rdi
            cdq
            push rdx
            push rdi
            push rsp
            pop rsi
            mov al, 0x3b
            syscall
            db 0,0 ; remainder
            dq  filesize                        ;   p_memsz
            dq  0x1000                          ;   p_align

phdr_dyn:                                           ; Elf64_Phdr
            dd  2                               ;   p_type
            dd  6                               ;   p_flags
            dq  dyn_offset                      ;   p_offset
            dq  _dyn                            ;   p_vaddr
    ; dynamic table in free space
    dyn_offset equ $ - $$
    _dyn:
            dq 0Ch, _start ; DT_INIT
            dq 5, 0   ; DT_STRTAB
            dq 6, 0    ; DT_SYMTAB

filesize      equ     $ - ehdr
```

```wasm
alex@ubuntu:~/Desktop/writeup$ nasm -f bin -o try4 try4.asm 
alex@ubuntu:~/Desktop/writeup$ LD_PRELOAD=./try3 /bin/true
$ 
alex@ubuntu:~/Desktop/writeup$ wc -c try4
191 try4
```

When we submit it we get the second flag:

![](https://i.imgur.com/7fJmzpA.png)
