# Bandit Level 6 → Level 7 Writeup
## Level Goal
The password for the next level is stored somewhere on the server and has all of the following properties:

- owned by user bandit7
- owned by group bandit6
- 33 bytes in size
## Commands you may need to solve this level
ls, cd, cat, file, du, find, grep

## Solution

After searching for various `find` parameters, the next command does the job:
```
bandit6@bandit:~$ find / -group bandit6 -user bandit7 -size 33c 2>/dev/null
/var/lib/dpkg/info/bandit7.password
bandit6@bandit:~$ cat /var/lib/dpkg/info/bandit7.password 
*****
```
Note - parameter `2>/dev/null` remove the Permission Denied error spam from the terminal by redirecting stderr to `/dev/null`.
