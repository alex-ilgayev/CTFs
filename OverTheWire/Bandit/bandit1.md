# Bandit Level 0 → Level 1 Writeup
## Level Goal
The password for the next level is stored in a file called readme located in the home directory. Use this password to log into bandit1 using SSH. Whenever you find a password for a level, use SSH (on port 2220) to log into that level and continue the game.

## Commands you may need to solve this level
ls, cd, cat, file, du, find

## Solution

We check the folder and see file named '-',
because '-' in bash is sign for stdin we can't print it's content using regular `cat` command:
```bash
bandit1@bandit:~$ ls
-
bandit1@bandit:~$ cat -

```
we write short python script to print it's content:
```bash
bandit1@bandit:~$ python
Python 2.7.13 (default, Sep 26 2018, 18:42:22) 
[GCC 6.3.0 20170516] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> with open('-','r') as f:
...     f.read()
... 
'*****\n'
>>> 
```
