# Bandit Level 8 → Level 9 Writeup
## Level Goal
The password for the next level is stored in the file data.txt and is the only line of text that occurs only once

## Commands you may need to solve this level
grep, sort, uniq, strings, base64, tr, tar, gzip, bzip2, xxd

## Helpful Reading Material
- [The unix commandline: pipes and redirects](http://www.westwind.com/reference/os-x/commandline/pipes.html)

## Solution

The next combination of linux commands pipeline will do the job:
```
bandit8@bandit:~$ cat data.txt | sort | uniq -c | sort | tail -n 1
      1 *****
```
### Explanation:
- `sort` - sorting so similar lines will be adjacent.
- `uniq -c` - merging similar lines and appending number of occurneces for each repeat.
- `sort` - sorting according to the number of occurneces.
- `tail -n 1` - returning the last line which is the only line with 1 occurence.
