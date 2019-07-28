# Bandit Level 4 → Level 5 Writeup
## Level Goal
The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the “reset” command.

## Commands you may need to solve this level
ls, cd, cat, file, du, find

## Solution

We see multiple files which one of them contains the flag:
```
bandit4@bandit:~$ cd inhere/
bandit4@bandit:~/inhere$ ls -lha
total 48K
drwxr-xr-x 2 root    root    4.0K Oct 16  2018 .
drwxr-xr-x 3 root    root    4.0K Oct 16  2018 ..
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file00
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file01
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file02
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file03
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file04
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file05
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file06
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file07
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file08
-rw-r----- 1 bandit5 bandit4   33 Oct 16  2018 -file09
bandit4@bandit:~/inhere$ 
```
I used a short script in python to open the files and print their content:
```
bandit4@bandit:~/inhere$ python
Python 2.7.13 (default, Sep 26 2018, 18:42:22) 
[GCC 6.3.0 20170516] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> for i in range(10):
...     filename = '-file0' +str(i)
...     with open(filename, 'r') as f:
...             print(f.read())
... 
����������~%	C[�걱>��| �
���U"7�w���H��ê�Q����(���#���
�T�v��(�ִ�����A*�
2J�Ş؇_�y7
��.A��u��#���w$N?c�-��Db3��=��
�=<�W�����ht�Z��!��{�U
                          �
+��pm���;��:D��^��@�gl�Q�
��@�%@���ZP*E��1�V���̫*����
*****

FPn�
      '�U���M��/u
                 XS
�mu�z���х
N�{���Y�d4����]3�����9(�
Q���
>>> 
```
