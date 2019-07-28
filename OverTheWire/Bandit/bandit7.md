# Bandit Level 7 → Level 8 Writeup
## Level Goal
The password for the next level is stored in the file data.txt next to the word millionth

## Commands you may need to solve this level
grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd

## Solution

Simple `grep` command will solve the case:
```
bandit7@bandit:~$ cat data.txt | grep millionth
millionth	*****
```
