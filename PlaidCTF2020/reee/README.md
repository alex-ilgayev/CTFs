# reee Writeup

[Download](https://play.plaidctf.com/files/reee-969a38276c46a65001faa2eaf75bf6ab3c444096b9d34094fd0e500badfaa73d.tar.gz)

> Hint: Flag format

> The flag format is pctf{$FLAG}. This constraint should resolve any ambiguities in solutions.

## Solution

```bash
alex@ELIKA-7490:/mnt/c/Users/alexil/Desktop/reee$ ./reee
need a flag!
Segmentation fault (core dumped)
alex@ELIKA-7490:/mnt/c/Users/alexil/Desktop/reee$ ./reee Give_me_flag_now!
Wrong!
```

Lets open IDA.

After a bit of reversing we have the next pseudo-code of `main`:

```c
int __fastcall main(int argc, char **argv, char **envp)
{
  int result;
  int j;
  int i;

  if ( argc <= 1 )
    puts("need a flag!");
  for ( i = 0; i <= 31336; ++i )
  {
    for ( j = 0; j <= 551; ++j )
      binary_blob[j] = convert_(binary_blob[j]);
  }
  if ( binary_blob() )
    result = puts("Correct!");
  else
    result = puts("Wrong!");
  return result;
}
```

And function `convert_` looks like:

```c
unsigned __int8 __fastcall convert_(unsigned __int8 val)
{
  b_val_3 += binary_256[++b_val_2];
  binary_256[b_val_2] ^= binary_256[b_val_3];
  binary_256[b_val_3] ^= binary_256[b_val_2];
  binary_256[b_val_2] ^= binary_256[b_val_3];
  return binary_256[(unsigned __int8)(binary_256[b_val_2] + binary_256[b_val_3])] + val;
}
```

Variables `b_val_1/b_val_2/b_val_3` are defined in `.bss` section, means are initialized to zero.

### Memory Dump

We must get some memory dump of the transformed `binary_blob` and run it. It probably contains some shellcode which will give us the flag.

There are many ways to dump memory. I have chosen to dump it during debug session using GDB.

I put breakpoint right before the call to `binary_blob()` is being called.

```python
gef➤  b *0x4006DB
Breakpoint 1 at 0x4006db
gef➤  r pctf{aaaabbbb}
gef➤  dump binary memory result.bin 0x04006E5 0x04006E5+552
```

We can now open `result.bin` using IDA while guiding him to disassemble as 64 bit.

![](https://i.imgur.com/WuWXoDc.png)

### Anti-Analysis

The shellcode has multiple easy-to-see anti-analysis method:

- Junk code with `EAX` calculation before branching. The branching will always be the same, and the math doesn't matter.

    For example:

    ```wasm
    mov     eax, 0AE5FE432h
    add     eax, 51A01BCEh
    inc     eax
    jnb     short near ptr loc_20+1
    ```

    `(0AE5FE432h + 51A01BCEh) & 0xffffffff = 0`

    means `jnb` will jump every time. (`EAX > 0`)

    My method for that trick was just to ignore the operations.

- Jumping one byte after disassembled operations making the code less readable.

    For example:

    ![](https://i.imgur.com/wz0jLdu.png)

    My solution for that was to undefine the code at `loc_20` using `u` in IDA, and redefine it in address `0x21`.

    After the fix:

    ![](https://i.imgur.com/zUyYOBS.png)

- Jumping one byte after current instruction:

    ![](https://i.imgur.com/MjpUnyM.png)

    Using instruction `EB FF` which has the following meaninig:

    - Jump short one byte before the next instruction (`FF` = -1)

    After the fix:

    ![](https://i.imgur.com/lTiuold.png)

### Debugging Shellcode

I used GDB to debug the shellcode and understand it's functionality.

The code is pretty simple, and after few runs I could rewrite it in python:

```python
xor_val = 0x50
s = 'pctf{sample_input}'
s = [ord(c) for c in s]

for _ in range(1337):
    for i in range(len(s)):
        new_val = s[i] ^ xor_val
        xor_val = s[i]
        s[i] = new_val
    
print([hex(c) for c in s])
```

The final result is being compared with the next hard-coded byte array:

`485F36353525142C1D01032D0C6F35617E340A44242C4A4619595B0E787429132C00`

So we need to reverse the algorithm to get the flag.

### (Algorithm) Reversing Time

Every time we doing xor operation, we do it against the previous byte of the previous iteration.

We can see it in the next "diagram" showing operation on short input containing bytes `ABCD`.

Each row shows the array result value after the operations has been made:

![](https://i.imgur.com/1cWt9bR.png)

We are given row `1336` in the diagram (the hard-coded byte array) and lets see how can we know row `1335`.

Lets assume we have the final `xor_val` value. According to the algorithm, `xor_val = D[1335]`.

So we can calculate `C[1335] = D[1335] ^ D[1336]`

We can do the same for `B` and `A` - `B[1335] = C[1335] ^ C[1336]`, `A[1335] = B[1335] ^ B[1336]`

To calculate the next row start value `D[1334]` is a bit more tricky.

If we xor the whole line `1336`: 

`A[1336] ^ B[1336] ^ C[1336] ^ D[1336]` 

Expand it:

`(A[1335] ^ D[1334]) ^ (A[1335] ^ B[1335]) ^ (B[1335] ^ C[1335]) ^ (C[1335] ^ D[1335])`

Remove double xors:

`D[1334]`. Wow.

Because we got the line as an input, we can easily calculate that.

### Script Time

Did we forget something ? Thats right, I said we can assume we know `xor_val` but we don't.

Well, we do know he is a byte, so he have only 256 possible values. 

Lets bruteforce it !

Another thing missing is the input length. so we are going to assume he is minimum 14 bytes length, and bruteforce the rest.

The script:

```python
import binascii

print('--- reverse order ---')

s_in_orig = binascii.unhexlify('485F36353525142C1D01032D0C6F35617E340A44242C4A4619595B0E787429132C00')

for i in range(14, len(s_in_orig)+1):
    print(f'len - {i}')
    for j in range(256):
        input_xor_val = j

        s_in = s_in_orig[:i]
        s_in = [c for c in s_in]
        s_next = [0] * len(s_in)

        for _ in range(1337):
            s_next[len(s_next) - 1] = input_xor_val
            for z in range(len(s_in) - 1)[::-1]:
                s_next[z] = s_in[z+1] ^ s_next[z+1]

            total_xor = 0
            for c in s_in:
                total_xor ^= c

            input_xor_val ^= total_xor
            s_in = s_next
            
            s_next = [0] * len(s_in)

        print(''.join([chr(c) for c in s_in]))
```

Lets redirect the output to a file, and search for our flag:

```bash
$ python3 reee.py > output
$ cat output | grep -a ctf
pctf{ok_nothing_too_fancy_there!}
```

Nice :)
