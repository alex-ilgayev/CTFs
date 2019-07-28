# Bandit Level 2 → Level 3 Writeup
## Level Goal
The password for the next level is stored in a file called spaces in this filename located in the home directory

## Commands you may need to solve this level
ls, cd, cat, file, du, find

## Helpful Reading Material
- [Google Search for “spaces in filename”](https://www.google.com/search?q=spaces+in+filename)

## Solution

After we checking the folder using `ls` command
```
bandit2@bandit:~$ ls -l
total 4
-rw-r----- 1 bandit3 bandit2 33 Oct 16  2018 spaces in this filename
```
we see a single file with multiple spaces.
we print it with `cat` with special character for spaces (or just click tab):
```
bandit2@bandit:~$ cat spaces\ in\ this\ filename 
*****
```
