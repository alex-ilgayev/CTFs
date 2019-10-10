# Lost Inside my PPTX Writeup

![](https://snag.gy/l7oYGQ.jpg)

Oh my, I'm locked outside my car! I mean, my car is right here but... I've lost my key!</br>

My car doesn't require a physical key, though. It's a digital one. Luckily, I've once written it in an odd way... Please help me find it! I'm running late for dinner O_o</br>

## Solution

Reading the [Instruction.txt](Instruction.txt) file giving us a pretty got lead how we should solve this challenge.</br>
We need to write code accessing the PPTX files programmatically, and traversing according to the algorithms explaines.
In Short 
- we gonna use [pptx](https://python-pptx.readthedocs.io/en/latest/) python library to open the powerpoint slides.
- we use it to open START.PPTX on the first slide and take the latter.
- we parse next powerpoint file and slide, and move to the next one.
- we keep doing it untill we get the flag.
Here's the [python](solution.py) code:
```python
from pptx import Presentation
import os

BASE_PATH = 'real_key/'

flag = ''

p = Presentation(BASE_PATH + 'START.pptx')
slide = p.slides[0]

while True:
    content = slide.shapes.title.text
    splitted = content.split(', ')

    char = splitted[0]
    next_pptx = BASE_PATH + splitted[1]
    next_pptx_slide = int(splitted[2])

    flag = flag + char

    if not os.path.exists(next_pptx):
        break

    p = Presentation(next_pptx)        
    slide = p.slides[next_pptx_slide - 1]

print(flag)
```
FLAG: CSA{7IZUWIKWIEQZNS9F5TVVY7JR9ZAB3CR2L0VA01BCJO1W47IEHGNT1G7QDHPJK5QVFH55JD45R4NF2TRF0VCMRGM3AFMDF2H8CYE1BMUQM50NFWB2WQNCYM4V}
