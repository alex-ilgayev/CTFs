# Bandit Level 10 → Level 11 Writeup
## Level Goal
The password for the next level is stored in the file data.txt, which contains base64 encoded data

## Commands you may need to solve this level
grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd

## Helpful Reading Material
- [Base64 on Wikipedia](http://en.wikipedia.org/wiki/Base64)

## Solution

Base64 is encoding/decoding format which converts binary to human-readable strings and vice-versa.
Decoding the file using simple command:
```bash
bandit10@bandit:~$ base64 -d data.txt 
The password is *****
```
