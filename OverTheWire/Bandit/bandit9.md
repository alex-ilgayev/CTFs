# Bandit Level 9 → Level 10 Writeup
## Level Goal
The password for the next level is stored in the file data.txt in one of the few human-readable strings, beginning with several ‘=’ characters.

## Commands you may need to solve this level
grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd

## Solution

Using the `strings` command which prints all the human-readable strings paired with `grep` will give us the flag:
```
bandit9@bandit:~$ strings data.txt  | grep =
2========== the
========== password
>t=	yP
rV~dHm=
========== isa
=FQ?P\U
=	F[
pb=x
J;m=
=)$=
========== *****
iv8!=
```
