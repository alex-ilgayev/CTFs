# Home Computer Writeup - forensics

Blunderbussing your way through the decision making process, you figure that one is as good as the other and that further research into the importance of Work Life balance is of little interest to you. You're the decider after all. You confidently use the credentials to access the "Home Computer."

Something called "desktop" presents itself, displaying a fascinating round and bumpy creature (much like yourself) labeled  "cauliflower 4 work - GAN post."  Your 40 hearts skip a beat.  It looks somewhat like your neighbors on XiXaX3.   ..Ah XiXaX3... You'd spend summers there at the beach, an awkward kid from ObarPool on a family vacation, yearning, but without nerve, to talk to those cool sophisticated locals.

So are these "Cauliflowers" earthlings? Not at all the unrelatable bipeds you imagined them to be.  Will they be at the party?  Hopefully SarahH has left some other work data on her home computer for you to learn more.

## Solution

After we extracted the attachment we see two files, `notes.txt` which is irrelevant to the challenge, and `family.ntfs` which represents raw `ntfs` format file.</br>
We try to mount it with `sudo mount -t ntfs family.ntfs /mnt/ntfs` and see some windows filesystem directories.</br>
We try to browse the user directories and find `credentials.txt` file:

```bash
alex@DESKTOP-FQ84F0U:/mnt/ntfs$ ls
 BOOTNXT  'Program Files'  'Program Files (x86)'   SSUUpdater.log   Setup.log   Users   Windows   bootmgr   pagefile.sys   swapfile.sys
alex@DESKTOP-FQ84F0U:/mnt/ntfs$ cd Users/
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users$ ls
Family  desktop.ini
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users$ cd Family/
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users/Family$ ls
Desktop  Documents  Downloads  Pictures  Videos
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users/Family$ cd Desktop/
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users/Family/Desktop$ ls
desktop.ini
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users/Family/Desktop$ cd ../Documents/
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users/Family/Documents$ ls
credentials.txt  document.pdf  preview.pdf
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users/Family/Documents$ cat credentials.txt
I keep pictures of my credentials in extended attributes.
```

What is extended attributes ? according to https://www.tuxera.com/community/ntfs-3g-advanced/extended-attributes/ :</br>
> Extended attributes are properties organized in (name, value) pairs, optionally set to files or directories in order to record information which cannot be stored in the file itself. They are supported by operating systems such as Windows, Linux, Solaris, MacOSX and others, with variations.

Means our filesystem holds more information which isn't seen right immidiatly.</br>
The Linux command reading file extended attribute is `getfattr`. lets try to dump all the data of the `credentials.txt` file:</br>

```bash
alex@DESKTOP-FQ84F0U:/mnt/ntfs/Users/Family/Documents$ getfattr -n user.FILE0 -d credentials.txt
# file: credentials.txt
user.FILE0=0siVBORw0KGgoAAAANSUhEUgAABNIAAAFTCAIAAABzubZeAAAAA3NCSVQICAjb4U/gAAAAGXRFWHRTb2Z0d2FyZQBnbm9tZS1zY3JlZW5zaG907wO/PgAAIABJREFUeJzs3XlgDPf/B/7Z3PfhSNxnLjmauONoiKiEJNQRxNlqtUpb6qhP3VV1qx6qFKVoBFUUcVWEICE0IcQRIagICbmvzTG/P/b729/83u/Z2dnNzm7C8/GXHe+Zee9kZvb9ep8ylmUZAAAAAAAAAGkYGToDAAAAAAAA8DpD2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAAAAASQtgJAAAAAAAAEkLYCQAAAAAAABJC2AkAAAAA...
...
...
...
...
7LPPiPnKVGFZ9pdffgkODjZs5KnP28bgZDJZRETExYsX7969u3Tp0k6dOomc2iEuLq5Hjx737t0jtuvw6jHUBaSvHtGdz+B1Fs+fP+/bt+/GjRvFzF5oaWnp7+//xRdfHDlyJCcn588//9RD/2qJSNevUrdH7tmzJze2Z1mW21ezsLCQO3Guj4+Pk5OT8iMRdt64cYMbshJdAPr168fbCKDnB0Q6b7311vnz57/++muil3JFRcV7770nPM6iluiFFiIjI9WOlhwzZgy9VKBieqTly5fTPWz79u1b24z+v/RZPDDU75dMJiPGcp84cYKo06msrIyOjuZuiYyM1MM0impJ2i1ctwcX7q+hqrOGAjHUnNtfo7Kykui1zttZg3ldCkgymWzjxo0LFiygJ7v+448/tFj87DWDsFNL9B2sdVBH70hU8NDlRe3Opd2vUd0kk8l69+79448/ZmZmpqamrl69esCAAWpfK/Hx8cSCxXqmz9um7nBzc1u4cOG1a9f++++/rVu3jho1Sm3LW1ZWFr3slQ6vHr0vffWI0xn28ZHL5SEhIVevXuX9XxMTEx8fn9GjR3/99df79u1LTU1VTGnz3XffhYWFKcY219/ODnS99eXLl3WybrUOZxNlGMbIyIgYusMttxFz2xKlNFdXV24NGsuy3Ilq1K53p6DnB0QiXbt2PXv2rJOTk0wm27p1KxE5XL16deXKldKdnV7rQuQSi6tXr6YnecrKylq/+k2dOnXUqFHIMuYAtGRQ7QQAAAAAAAAAoETQBgMAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQImg2gkAAAAAAAAAQIn+D5+sXazh0CUuAAAAAElFTkSuQmCC
```

We can see that the "key" is `user.FILE0` and the value is the very long string which probably represents some file.</br>
At first I thought the strings is base64 encoded for binary file, but I was wrong, and this isn't base64 encoding.</br>
Later i've seen `--only-values` parameter for the `getfattr`.</br>
If we use the following command: `getfattr -n user.FILE0 --only-values credentials.txt` we getting binary. if we redirect it to a file we'll get a picture file which looks like:</br>
![pic](https://imgur.com/a/Rgr6Dj6)

flag - CTF{congratsyoufoundmycreds}


