# Bandit Level 3 → Level 4 Writeup
## Level Goal
The password for the next level is stored in a hidden file in the inhere directory.

## Commands you may need to solve this level
ls, cd, cat, file, du, find

## Solution

We listing all the files (include hidden) with `ls -lha`:
```
bandit3@bandit:~$ cd inhere/
bandit3@bandit:~/inhere$ ls -lha
total 12K
drwxr-xr-x 2 root    root    4.0K Oct 16  2018 .
drwxr-xr-x 3 root    root    4.0K Oct 16  2018 ..
-rw-r----- 1 bandit4 bandit3   33 Oct 16  2018 .hidden
bandit3@bandit:~/inhere$ 
```
and printing the hidden file:
```
bandit3@bandit:~/inhere$ cat .hidden
*****
```
