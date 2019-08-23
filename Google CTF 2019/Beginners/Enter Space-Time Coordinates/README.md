# Enter Space-Time Coordinates Writeup - Misc

Ok well done. The console is on. It's asking for coordinates. Beating heavily on the console yields little results, but the only time anything changes on your display is when you put in numbers.. So what numbers are you going to go for?  You see the starship's logs, but is there a manual? Or should you just keep beating the console?

## Solution

We have two files: `log.txt` which is a text file, and `rand2` which is ELF.</br>
`log.txt` contains some sort of coordinates to places:

```bash
0: AC+79 3888{6652492084280_198129318435598}
1: Pliamas Sos{276116074108949_243544040631356}
2: Ophiuchus{11230026071572_273089684340955}
3: Pax Memor -ne4456 Hi Pro{21455190336714_219250247519817}
4: Camion Gyrin{235962764372832_269519420054142}
```

and running `rand2` gives us:

```bash
Travel coordinator
0: AC+79 3888 - 267947582280709, 262517165522059
1: Pliamas Sos - 189951763210885, 188450838153441
2: Ophiuchus - 219363759924203, 179610625409966
3: Pax Memor -ne4456 Hi Pro - 53875516284580, 128088264136299
4: Camion Gyrin - 180382952992374, 198456577981004
5: CTF - <REDACTED>

Enter your destination's x coordinate:
>>> flag
Enter your destination's y coordinate:
>>> Arrived somewhere, but not where the flag is. Sorry, try again.
```

probably the executable contains ctf flag inside him so we try to use `strings` and there we receive the flag:</br>

```bash
alex@desktop:/mnt/d/Projects/github-ctfs/CTFs/Google CTF 2019/Beginners/Enter Space-Time Coordinates$ strings rand2
...
Enter your destination's x coordinate:
>>>
Enter your destination's y coordinate:
>>>
Arrived at the flag. Congrats, your flag is: CTF{welcome_to_googlectf}
Arrived somewhere, but not where the flag is. Sorry, try again.
...
```

flag - CTF{welcome_to_googlectf}
