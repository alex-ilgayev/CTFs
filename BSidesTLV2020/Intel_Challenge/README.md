# Intel's Challenge

Last week took place one of the leading cyber security conference, the BSidesTLV. Prior to the event they published an even more awesome [CTF competition](https://ctf20.bsidestlv.com/) which my team has participated, and took the 3rd place.

During the event, Intel's HR representatives had published an interesting security challenge when 5 first solvers will receive a drone as a prize.  

## The Challenge

Intel posted a QR code which contained the next string:

```
UEsDBBQAAAAIAG2N2VA10GqVbwEAABwDAAAJAAAAUnVsZXMudHh0bVJBTsNADLxX6h8WziEI
uPHKRM3SLtmmbRo1yX6BA8+YZ/AFZry0RRRFiuyxPfZ4/fXxiQYeEyr+0+tygZrACRFrNHfL
BYGEEXtGd4w+lcQ7zEiOaT3RPQK2ckQxX4FkDskckdZwmgFvchwDAysOzoomBWb1dPy1SFbJ
FjPxmh0n+HK5eC6ZHUi0QcwV6hlF1t+j0xAht+lNUpunHOgG8nq5/po0YTa+pKYNzYnOeyFv
5AYmzeblzSY/yU/O1uEx3HAXmcbjQOToKNSj1S6KW46Odo+VM3EBUya7VDgzdqqrs9jqPymP
5wFrjts7tMocTHyUwMo2l9RlzFvusb2hicypsznbajyCcSHmWSqxFSqODywNOU9LYLsV4aRm
DUmiRCEUEmjDHOz9GlVo7ZWEdZYYfmHJjMbZLkJ++chBOowX5WsiG2XyDl5KvThOWUyja+Q3
ZA31nzfp8oWdr7S7ZBvw86J7HYLCKR8bEtt8A1BLAwQUAAAACABBjdlQuey5f3UBAADyCwAA
EQAAAEludGVsX2NoYWxsZW5nZS5Te83E8GrChAlp/PItDCAwIbT7TfMbneCw8CzR6Cwu45PH
XT/wMzDwxh93/cLIysnQG/oh7bjrDwbe7u8dsVeOu16NCNWIPe56MywsJPS4690UvUDn464P
U4IDYo67Po0TYBU57vqyNlTBsMP3bRdTh+t//m2u/224ZDL1gewu1/8dTE7N7xhLn/SWXuk+
aHzp+/cuF9EPRochklv4tjOcFXB062LrutFyoPRefJzxgWigYxmGDRgFAwlGwUCCUTCQYBQM
JBgFAwlGwUCCwQWUwcDTL8TVJ969KDWxJD4gJzE5NT4kPz48vyhbESLPwOASFFqfF+Rs5FCi
6WogoiouYD7BSVZc3stTKsjX20K5JK1AP7mgmIGhLh4CPP0CQkMUIv1DgxTcfBzdFTxcg1zj
EaCOgQKwl5vhscB//Yf+XwwS/D8wsvh/YGCe8CNAYMIPDYVFr5mZml4xMjJVMH9kZGb4yMjQ
5cR0UU2b6cLb50B1LApuAFBLAQIfABQAAAAIAG2N2VA10GqVbwEAABwDAAAJACQAAAAAAAAA
IAAAAAAAAABSdWxlcy50eHQKACAAAAAAAAEAGABAhNL8/krWAUCE0vz+StYB5bVx0f5K1gFQ
SwECHwAUAAAACABBjdlQuey5f3UBAADyCwAAEQAkAAAAAAAAACAAAACWAQAASW50ZWxfY2hh
bGxlbmdlLlMKACAAAAAAAAEAGADNtPvJ/krWAc20+8n+StYB3Rjth/5K1gFQSwUGAAAAAAIA
AgC+AAAAOgMAAAAA
```

## Solution

I output the base64 decoding into a file, and checked it type:

```bash
echo -n "UEsDBBQAAAAIAG2N2VA10GqVbwEAABwDAAAJAAAAUnVsZXMudHh0bVJBTsNADLxX6h8WziEI
> uPHKRM3SLtmmbRo1yX6BA8+YZ/AFZry0RRRFiuyxPfZ4/fXxiQYeEyr+0+tygZrACRFrNHfL
> BYGEEXtGd4w+lcQ7zEiOaT3RPQK2ckQxX4FkDskckdZwmgFvchwDAysOzoomBWb1dPy1SFbJ
> FjPxmh0n+HK5eC6ZHUi0QcwV6hlF1t+j0xAht+lNUpunHOgG8nq5/po0YTa+pKYNzYnOeyFv
> 5AYmzeblzSY/yU/O1uEx3HAXmcbjQOToKNSj1S6KW46Odo+VM3EBUya7VDgzdqqrs9jqPymP
> 5wFrjts7tMocTHyUwMo2l9RlzFvusb2hicypsznbajyCcSHmWSqxFSqODywNOU9LYLsV4aRm
> DUmiRCEUEmjDHOz9GlVo7ZWEdZYYfmHJjMbZLkJ++chBOowX5WsiG2XyDl5KvThOWUyja+Q3
> ZA31nzfp8oWdr7S7ZBvw86J7HYLCKR8bEtt8A1BLAwQUAAAACABBjdlQuey5f3UBAADyCwAA
> EQAAAEludGVsX2NoYWxsZW5nZS5Te83E8GrChAlp/PItDCAwIbT7TfMbneCw8CzR6Cwu45PH
> XT/wMzDwxh93/cLIysnQG/oh7bjrDwbe7u8dsVeOu16NCNWIPe56MywsJPS4690UvUDn464P
> U4IDYo67Po0TYBU57vqyNlTBsMP3bRdTh+t//m2u/224ZDL1gewu1/8dTE7N7xhLn/SWXuk+
> aHzp+/cuF9EPRochklv4tjOcFXB062LrutFyoPRefJzxgWigYxmGDRgFAwlGwUCCUTCQYBQM
> JBgFAwlGwUCCwQWUwcDTL8TVJ969KDWxJD4gJzE5NT4kPz48vyhbESLPwOASFFqfF+Rs5FCi
> 6WogoiouYD7BSVZc3stTKsjX20K5JK1AP7mgmIGhLh4CPP0CQkMUIv1DgxTcfBzdFTxcg1zj
> EaCOgQKwl5vhscB//Yf+XwwS/D8wsvh/YGCe8CNAYMIPDYVFr5mZml4xMjJVMH9kZGb4yMjQ
> 5cR0UU2b6cLb50B1LApuAFBLAQIfABQAAAAIAG2N2VA10GqVbwEAABwDAAAJACQAAAAAAAAA
> IAAAAAAAAABSdWxlcy50eHQKACAAAAAAAAEAGABAhNL8/krWAUCE0vz+StYB5bVx0f5K1gFQ
> SwECHwAUAAAACABBjdlQuey5f3UBAADyCwAAEQAkAAAAAAAAACAAAACWAQAASW50ZWxfY2hh
> bGxlbmdlLlMKACAAAAAAAAEAGADNtPvJ/krWAc20+8n+StYB3Rjth/5K1gFQSwUGAAAAAAIA
> AgC+AAAAOgMAAAAA" | base64 -d > output

file output
output: Zip archive data, at least v2.0 to extract
```

We can see the output is a zip file. We have two files inside it:

- `Rules.txt` - Nothing interesting.
- `Intel_challenge.S` - Main challenge.

The `.S` suffix is confusing, and its actually a DOS executable and not assembly file:

```bash
file Intel_challenge.S
Intel_challenge.S: DOS executable (COM)
```

I tried executing it with two differnt methods:

- Windows 7 has `ntvdm.dll` - a DOS "virtual machine" - Execution failed.
- Using `DOSBox` - Execution failed.

So we have to analyze it statically. lets open it with IDA.

### Part 1 - x86 Shellcode

IDA is recognizing only first parts of the shellcode, and fails to disassemble the last parts.

During analysis I noticed we can divide the shellcode into 3 parts:

**Part 1**

```asm
seg000:00000011 55                                push    ebp
seg000:00000012 8B EC                             mov     ebp, esp
seg000:00000014 83 EC 2C                          sub     esp, 2Ch
seg000:00000017 53                                push    ebx
seg000:00000018 56                                push    esi
seg000:00000019 57                                push    edi
seg000:0000001A 6A 15                             push    15h
seg000:0000001C 5B                                pop     ebx
seg000:0000001D 6A 0A                             push    0Ah
seg000:0000001F 33 C9                             xor     ecx, ecx
seg000:00000021 C7 45 F0 0F 00 00+                mov     dword ptr [ebp-10h], 0D00000Fh
seg000:00000021 0D
seg000:00000028 5F                                pop     edi
seg000:00000029 C7 45 F4 01 05 09+                mov     dword ptr [ebp-0Ch], 90501h
seg000:00000029 00
seg000:00000030 8D 55 F0                          lea     edx, [ebp-10h]
seg000:00000033 66 C7 45 F8 00 0D                 mov     word ptr [ebp-8], 0D00h
seg000:00000039 8B F7                             mov     esi, edi
seg000:0000003B 88 5D D4                          mov     [ebp-2Ch], bl
seg000:0000003E C7 45 D5 58 55 28+                mov     dword ptr [ebp-2Bh], 5D285558h
seg000:0000003E 5D
seg000:00000045 C7 45 D9 56 56 54+                mov     dword ptr [ebp-27h], 55545656h
seg000:00000045 55
seg000:0000004C C7 45 DD 64 2E 51+                mov     dword ptr [ebp-23h], 43512E64h
seg000:0000004C 43
seg000:00000053 C7 45 E1 64 53 50+                mov     dword ptr [ebp-1Fh], 5C505364h
seg000:00000053 5C
seg000:0000005A C7 45 E5 5E 10 05+                mov     dword ptr [ebp-1Bh], 1405105Eh
seg000:0000005A 14
seg000:00000061 C7 45 E9 7D 55 20+                mov     dword ptr [ebp-17h], 3120557Dh
seg000:00000061 31
seg000:00000068 88 4D ED                          mov     [ebp-13h], cl
```

This part is the initialization phase. 

`ebp-10h` is being initialized with the next 10 bytes: `0F00000D01050900000D0000`

`ebp-2Ch` is being initialized with the next bytes:

```python
enc = b'\x15'
enc += struct.pack('<I', 0x5D285558)
enc += struct.pack('<I', 0x55545656)
enc += struct.pack('<I', 0x43512E64)
enc += struct.pack('<I', 0x5C505364)
enc += struct.pack('<I', 0x1405105E)
enc += struct.pack('<I', 0x3120557D)
```

**Part 2**

```asm
seg000:0000006B                   loc_6B:                                 ; CODE XREF: seg000:00000085↓j
seg000:0000006B 8A 02                             mov     al, [edx]
seg000:0000006D 88 45 FF                          mov     [ebp-1], al
seg000:00000070 0F B6 45 FF                       movzx   eax, byte ptr [ebp-1]
seg000:00000074 3C 0A                             cmp     al, 10
seg000:00000076 1C 69                             sbb     al, 105
seg000:00000078 2F                                das
seg000:00000079 88 45 FF                          mov     [ebp-1], al
seg000:0000007C 8A 45 FF                          mov     al, [ebp-1]
seg000:0000007F 88 02                             mov     [edx], al
seg000:00000081 42                                inc     edx
seg000:00000082 83 EE 01                          sub     esi, 1
seg000:00000085 75 E4                             jnz     short loc_6B
seg000:00000087 8D 75 D4                          lea     esi, [ebp-2Ch]
```

Because `edx` is set with `ebp-10h` we have some calculation on that array.

For each element (of total length 10) we transform him according the next assembly lines:

```asm
cmp     al, 10
sbb     al, 105
das
```

For easier calculation, I used online disassemble emulator to calculate the new array: `46303044313539303044`

**Part 3**

```asm
seg000:0000008A                   loc_8A:                                 ; CODE XREF: seg000:000000AA↓j
seg000:0000008A 8B C1                             mov     eax, ecx 
seg000:0000008C 33 D2                             xor     edx, edx
seg000:0000008E F7 F7                             div     edi
seg000:00000090 8A 44 15 F0                       mov     al, [ebp+edx-10h]
seg000:00000094 32 C3                             xor     al, bl
seg000:00000096 88 45 FF                          mov     [ebp-1], al
seg000:00000099 8A 45 FF                          mov     al, [ebp-1]
seg000:0000009C B4 0E                             mov     ah, 0Eh
seg000:0000009E B7 00                             mov     bh, 0
seg000:000000A0 CD 10                             int     10h             ; - VIDEO -
seg000:000000A2 41                                inc     ecx
seg000:000000A3 46                                inc     esi
seg000:000000A4 8A 06                             mov     al, [esi]
seg000:000000A6 8A D8                             mov     bl, al
seg000:000000A8 84 C0                             test    al, al
seg000:000000AA 75 DE                             jnz     short loc_8A 
seg000:000000AC 5F                                pop     edi
seg000:000000AD 5E                                pop     esi
seg000:000000AE 33 C0                             xor     eax, eax
seg000:000000B0 5B                                pop     ebx
seg000:000000B1 90                                nop
```

That code actually does simple XOR encryption, with `ebp-10h` key (of size 10), and `ebp-2ch` cipher text.

The next simple python script will give us the plain text:

```asm
import binascii
import struct

key = '46303044313539303044'

enc = b'\x15'
enc += struct.pack('<I', 0x5D285558)
enc += struct.pack('<I', 0x55545656)
enc += struct.pack('<I', 0x43512E64)
enc += struct.pack('<I', 0x5C505364)
enc += struct.pack('<I', 0x1405105E)
enc += struct.pack('<I', 0x3120557D)

key = binascii.unhexlify(key)

idx = 0
dec = []
for c in enc:
    dec.append(c ^ key[idx % 10])
    idx += 1

print(''.join([chr(c) for c in dec]))
```

Plain text - `Shellcode has been ARMed`

After the challenge was over, I tried using [unicorn-engine](https://github.com/unicorn-engine/unicorn) to solve it. Every character is being printed using the `0x10` interrupt code, and actual character is `al`. So the unicorn code just hooks interrupts, and prints the according character.

The next code should do that:

```python
import binascii

from unicorn import *
from unicorn.x86_const import *

# Hooks Callbacks
def hook_code(uc, address, size, user_data):
    pass
    # print(hex(address))

def hook_intr(uc, intno, user_data):
    ch = emu.reg_read(UC_X86_REG_EAX, 0) & 0xff
    ch = chr(ch)
    print(ch, end='')

ADDRESS    = 0
ESP_OFFSET = 0x1000
MEM_SIZE   = 16 * 1024 * 1024 
CODE = binascii.unhexlify('EB0200EA909090660F1F84000000000090558BEC83EC2C5356576A155B6A0A33C9C745F00F00000D5FC745F4010509008D55F066C745F8000D8BF7885DD4C745D55855285DC745D956565455C745DD642E5143C745E16453505CC745E55E100514C745E97D552031884DED8A028845FF0FB645FF3C0A1C692F8845FF8A45FF88024283EE0175E48D75D48BC133D2F7F78A4415F032C38845FF8A45FFB40EB700CD1041468A068AD884C075DE5F5E33C05B')

emu = Uc(UC_ARCH_X86, UC_MODE_32)
emu.mem_map(ADDRESS, MEM_SIZE)
end_mem_address = ADDRESS + MEM_SIZE

# Loading Code
emu.mem_write(ADDRESS, CODE)

# Initialize Stack
emu.reg_write(UC_X86_REG_ESP, ADDRESS + ESP_OFFSET)

# Initialize Registers
emu.reg_write(UC_X86_REG_EBP, 0)
emu.reg_write(UC_X86_REG_EAX, 0)
emu.reg_write(UC_X86_REG_EBX, 0)
emu.reg_write(UC_X86_REG_ECX, 0)
emu.reg_write(UC_X86_REG_EDX, 0)
emu.reg_write(UC_X86_REG_EDI, 0)
emu.reg_write(UC_X86_REG_ESI, 0)
emu.reg_write(UC_X86_REG_EFLAGS, 0x0)

# Initizlie Hooks
emu.hook_add(UC_HOOK_CODE, hook_code)
emu.hook_add(UC_HOOK_INTR, hook_intr)

# Emulation
try:
    emu.emu_start(ADDRESS, ADDRESS + len(CODE)) 
except UcError as e:
    print(str(e)) 
```

### Part 2 - ARM Shellcode

From previous decrypted message: `Shellcode has been ARMed` we understand we have another shellcode, for ARM architecture. 

We assume the moment that ARM part starts right after the x86 shellcode. We can also deduct the following:

- ARM part starts at `0xB00`, and contains the string: `######INTEL_Great_Place_To_Work!######`
- Some "encrypted blob" at `0xB28`
- The next string at `0xB50`:

```
~_______INPUT YOUR FLAG HERE___________~
```

- At `0xBB4` we see something that can be a potential shellcode.

Given my inexperience with the ARM architecture, I used the next [ARM online disassembler](https://armconverter.com/) for the shellcode. The only reasonable code was THUMB mode:

```asm
lsrs r5, r7, #0xe
b #0x606
vrhadd.u16 d14, d0, d31
mov.w r0, #0xb00        ; ARM part start here
mov.w r4, #1            ; return value
mov.w r3, #0            ; Encrypted text index
ldrb.w r1, [r0, #0x50]  ; FLAG offset
ldrb.w r2, [r0, #0x28]  ; Encrypted text offset
sub.w r2, r2, r3
eor.w r1, r2, r1
ldrb r2, [r0]
add.w r3, r3, #1
add.w r0, r0, #1
cmp r2, r1              ;
bne #0x38               ; if jump then compare fails.
cmp r3, #0x26           ; flag length
beq #0x3c               ; success
b #0x14     
mov.w r4, #0
mov r0, r4
```

The code takes the `0xB28` decrypted array, for each element substract the index of the character, XORes with the "FLAG" at `0xB50` and compared to the string at `0xB00`.

So we can calculate the flag by that. The next script does that:

```python
import binascii
import struct

r0 = '232323232323494E54454C5F47726561745F506C6163655F546F5F576F726B21232323232323'
r2 = '4452557F6E5243324074294530142517103790421D171F4A491A524D4B38237466702F637073'

r0 = binascii.unhexlify(r0)
r2 = binascii.unhexlify(r2)

new_r2 = [0] * len(r2)
for i in range(len(r2)):
    new_r2[i] = r2[i] - i
r2 = new_r2

idx = 0
dec = []
for c in r0:
    dec.append(c ^ r2[idx])
    idx += 1

print(''.join([chr(c) for c in dec]))
```

The decrypted text is an email address where the solution is being sent to.

Similar to the first x86 part, I wanted to solve it using [unicorn-engine](https://github.com/unicorn-engine/unicorn) to learn it better.

To do that, I initialized the flag with zeroes, and for each `cmp r2, r1` I printed their XOR. I also set the comparison to be true so the execution won't stop.

The next script should work:

```python
import binascii

from unicorn import *
from unicorn.x86_const import *
from unicorn.arm_const import *
from capstone import *
from capstone.arm import *
from capstone.x86 import *

cs = Cs(CS_ARCH_ARM, CS_MODE_THUMB)

# Hooks Callbacks
def hook_code(uc, address, size, user_data):
    code = uc.mem_read(address, size)
    asm = list(cs.disasm(code, size))
    if len(asm) == 0:
        print(f'>>> 0x{address:x}\t{binascii.hexlify(code)}\tdisasm failure')
    for ins in asm:
        pass
        # print(f'>>> 0x{address:x}\t{binascii.hexlify(code)}\t{ins.mnemonic} {ins.op_str}') 
    if ins.mnemonic == 'cmp' and ins.op_str == 'r2, r1':
        r1 = uc.reg_read(UC_ARM_REG_R1)
        r2 = uc.reg_read(UC_ARM_REG_R2)
        print(chr(r1 ^ r2), end='')
        uc.reg_write(UC_ARM_REG_R2, r1) # to continue the loop

BASE_ADDRESS = 0
ESP_OFFSET = 0x1000
CODE_ADDRESS = BASE_ADDRESS + 0xBB4
DATA_ADDRESS = BASE_ADDRESS + 0xB00
MEM_SIZE   = 16 * 1024 * 1024 
CODE = binascii.unhexlify('BD0B00E310FF2FE14FF430604FF001044FF0000390F8501090F82820A2EB030282EA0101027803F1010300F101008A4202D1262B02D0EDE74FF000042046')
DATA = binascii.unhexlify('232323232323494E54454C5F47726561745F506C6163655F546F5F576F726B2123232323232300004452557F6E5243324074294530142517103790421D171F4A491A524D4B38237466702F63707300007E5F5F5F5F5F5F5F494E50555420594F555220464C414720484552455F5F5F5F5F5F5F5F5F5F5F7E00')

emu = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
emu.mem_map(BASE_ADDRESS, MEM_SIZE)
end_mem_address = BASE_ADDRESS + MEM_SIZE

# Loading Code and Data
emu.mem_write(CODE_ADDRESS, CODE)
emu.mem_write(DATA_ADDRESS, DATA)

# Initialize Hooks
emu.hook_add(UC_HOOK_CODE, hook_code)

# Initializing the flag data
emu.mem_write(0xB50, b'\x00' * 41)

# Emulation
try:
    emu.emu_start(CODE_ADDRESS, CODE_ADDRESS + len(CODE)) 
except UcError as e:
    print(str(e))
```

To sum it up, Intel's produced great beginner-intermediate challenge, and I used that opportunity deepen my proficiency with the awesome `unicorn-engine` project.
