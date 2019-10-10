# Pinball Cipher Writeup

![text](https://snag.gy/sXfjGC.jpg)

Time is of the essence, so I shall skip the introductions.</br>
My children have disappeared – I haven’t heard from them in weeks. In my relentless searches, all I was able to obtain is this single short message they have left for me.</br>
The message is encrypted with the Pinball Cipher, a toy system which I authored personally for our family use. Unfortunately, the message author used a key unknown to me.</br>
I have provided you with the encrypted message, as well as the encryption software for this Pinball Cipher (for both Windows and Linux).</br>
Yours Truly, Sr. Reginald Hargreeves</br>

## Solution

The readme.pdf file explains we have some encrypted message, and we also have the encrypting software (for Windows and Linux).
Lets try to use the encrypting software:

```bash
alex@desktop:/mnt/d/Google Drive/Cyber Hacking/Challenges/CheckPointCTF2019/Pinball cipher$ ./pinball.elf
Pinball Encryptor 1.0.0
Sir Reginald Hargreeves
Encrypts and decrypts messages.

USAGE:
    pinball.elf <SUBCOMMAND>

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

SUBCOMMANDS:
    help         Prints this message or the help of the given subcommand(s)
    table        Displays the encryption table.
    transform    Performs encryption/decryption (both are the same operation).
alex@desktop:/mnt/d/Google Drive/Cyber Hacking/Challenges/CheckPointCTF2019/Pinball cipher$ ./pinball.elf table
177 030 077 225 170 116 089
228 139 058 083 195 202 201
197 113 114 053 184 105 043
178 029 210 090 150 045 212
135 240 099 051 147 085 060
156 039 169 101 078 180 165
075 108 102 163 166 027 092
204 046 015 198 209 086 120
232 172 106 154 226 023 057
054 141 216 149 153 142 071
alex@desktop:/mnt/d/Google Drive/Cyber Hacking/Challenges/CheckPointCTF2019/Pinball cipher$ ./pinball.elf transform
error: The following required arguments were not provided:
    <INPUT_FILE>
    <OUTPUT_FILE>
    <KEY_PY>
    <KEY_PX>
    <KEY_VY>
    <KEY_VX>

USAGE:
    pinball.elf transform <INPUT_FILE> <OUTPUT_FILE> <KEY_PY> <KEY_PX> <KEY_VY> <KEY_VX>

For more information try --help
```

As we see, the encryption uses some sort of 7x7 table, and receives 4 parameters for the encryption.</br>
Lets create sample input file and try to encrypt and decrypt it:

```shell
alex@desktop:/mnt/d/Google Drive/Cyber Hacking/Challenges/CheckPointCTF2019/Pinball cipher$ cat in
This Is Plain Text !
alex@desktop:/mnt/d/Google Drive/Cyber Hacking/Challenges/CheckPointCTF2019/Pinball cipher$ ./pinball.elf transform in ou 1 1 - +
XORing plaintext byte with 139
XORing plaintext byte with 77
Boing!
XORing plaintext byte with 83
XORing plaintext byte with 184
XORing plaintext byte with 45
XORing plaintext byte with 60
Boing!
XORing plaintext byte with 180
XORing plaintext byte with 166
XORing plaintext byte with 198
XORing plaintext byte with 106
XORing plaintext byte with 141
Boing!
XORing plaintext byte with 232
Boing!
XORing plaintext byte with 46
XORing plaintext byte with 102
XORing plaintext byte with 101
XORing plaintext byte with 147
XORing plaintext byte with 45
XORing plaintext byte with 43
Boing!
XORing plaintext byte with 202
XORing plaintext byte with 170
Boing!
XORing plaintext byte with 83
XORing plaintext byte with 114
```

Seems like the algorithm is xor encryption with series of number dependant on X, Y, and increment/decrement of X and Y axis.</br>
To sum it up, we have 7x7x2x2 key options.</br>
Because we know the text was written in plain English, we can bruteforce and seek of readable text.</br>
The code for the [solution](solution.py):

```python
import os

PINBALL_PATH = './pinball.elf'
for i in range(0,7):
    for j in range(0,7):
        for vy in ['+', '-']:
            for vx in ['+', '-']:
                py = str(i)
                px = str(j)
                params = ' transform msg.enc output ' +  py + ' ' + px + ' ' + vy + ' ' + vx
                os.system(PINBALL_PATH + params)

                with open('aggregated_output', 'ab') as f:
                    with open('output', 'rb') as f2: 
                        f.write(f2.read())
                        line = str(0) + "\n\n"
                        f.write(line.encode('utf-8'))
```

Finally, we open all the decrypted file and search for the message:</br>

```bash
alex@desktop:/mnt/d/Google Drive/Cyber Hacking/Challenges/CheckPointCTF2019/Pinball cipher$ strings aggregated_output | grep CSA
Congrats! The flag for the pinball cipher is: CSA{wE_sh0uLd_hav3_BeEn_n1cer_t0_oUr_siST3r}0
```

FLAG: CSA{wE_sh0uLd_hav3_BeEn_n1cer_t0_oUr_siST3r}
