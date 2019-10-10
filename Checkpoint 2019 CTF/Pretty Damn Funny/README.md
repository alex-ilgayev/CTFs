# Pretty Damn Funny Writeup

![text](https://i.imgur.com/B2J3UHG.png)

In the heat of the battle we managed to intercept a raven flying over the battlefield. The raven carried a USB that contained a file with a message for the enemy. Help us recover the message from the file!</br>
</br>
Hint: You may be interested in reading about Incremental updates.</br>

## Solution

We were given a single pdf file which was completely blank.</br>
If we try to mark it with the mouse to find hidden text, we find one at the bottom of the pdf file:</br>
`between the lines`.</br>
In addition to the `Hint: You may be interested in reading about Incremental updates.` hint we understand that we have to dig into PDF file format to find the flag.</br>
</br>
There are lots of information regarding PDF internals. Some of which I used to learn:</br>
<https://www.youtube.com/watch?v=KmP7pbcAl-8> - good youtube video explaining internals by one of the developers.</br>
<https://resources.infosecinstitute.com/pdf-file-format-basic-structure/> - very good explanation of PDF structure. </br>
If we sum it up, the following explains PDF structure:</br>
![pdf structure](https://mk0resourcesinfm536w.kinstacdn.com/wp-content/uploads/110612_1237_PDFFileForm2.png)</br>

- Header - metadata and general information regarding the file.
- Body - PDF file is built upon objects. this section represents all the object in the file in unordered way. The pdf file is structured like a tree with hierarchy. Each object consist type, and "son objects".
- xref Table - gives information where to find each object by offset.
- Trailer - gives information where to find the first PDF object (root object).

Constructing the object tree using text editor on the PDF format is almost impossible. Thus we used external program called 'PDFXplorer'.</br>
![pdf](https://i.imgur.com/FBDBeOu.png)</br>
After wasting a lot of time understanding the PDF structure using the parser, we reached dead end.</br>
The tree structure had 5-6 depth children, and had multiple 'stream' type object.</br>
We can see one here:</br>
![pdf](https://i.imgur.com/Pos7EWK.png)</br>
The name is ascii encoded string of `FlateDecode`, and we can see the binary stream data starts with `789c` which indicates zip file, but we didn't managed to extract meaningful data out of it.</br>
</br>

When I kept searching for another way for the solution I googled `pdf incremental updates`, and saw using simple text editor that the file had multiple `%%EOF` signatures:

```pdf
trailer
<</Size 71/Root 67 0 R/Info 70 0 R>>
startxref
10927
%%EOF
69 0 obj
<</Type/Page/Parent 68 0 R/MediaBox [0 0 612 792]/Contents 60 0 R>>
endobj
xref
0 1
0000000000 65535 f
69 1
0000012424 00000 n
trailer
<</Size 71/Root 67 0 R/Info 70 0 R/Prev 10927>>
startxref
12508
%%EOF
...
...
```

Incremental method of PDF format allows us to change PDF content without modifying the original content. It is the parser responsibility to apply updates according to the changes added at the end.</br>
If we use this architecture:</br>
![pdf](https://www.debenu.com/kb/wp-content/uploads/incremental_update.png)</br>
upon our data, we will receive:</br>
![pdf](https://i.imgur.com/xvSam3y.png)</br>
If we keep observe all the incremental updates we will see a pattern:

- All the updates are for object 69 
- For each object 59, the update defined multiple childrens:
  - parent (the same for everyone)
  - mediabox (the same for everyone)
  - object content (from one of the PDF objects)
We seen that each 'stream' object contains zipped binary data. Lets write code which goes through all the content objects specified in object 69, and print it's unzipped value.</br>
For finding the zipped binary data, we hexlify the PDF and using this regex:</br>
`res = re.findall('73747265616d0a(.*?)0a656e6473747265616d0a', all_bytes_hex_str)`</br>
And we made hardcoded object list according to the pdf incremental structure:</br>
`array = [20, 60, 48, 46, 40, 42, 17, 44, 35, 56, 9, 45, 4, 35, 41, 19, 36, 35, 55, 21, 52, 53, 13]`</br>
When we attempt to run the code we receive the following output:

```
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%C\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%S\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%A\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%{\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%k\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%e\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%3\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%P\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%_\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%c\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%a\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%L\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%m\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%_\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%4\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%N\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%d\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%_\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%r\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%7\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%f\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%M\r[( the lines)] TJ\rET'
b'BT\r/F1 20 Tf\r1 g\r[(read between)] TJ%}\r[( the lines)] TJ\rET'
```

So the full code is the following:

```python
import zlib
import binascii
import re

with open('raven.pdf', 'rb') as f:
    all_bytes = f.read()
    all_bytes_hex = binascii.hexlify(all_bytes)
    all_bytes_hex_str = all_bytes_hex.decode('utf-8')

res = re.findall('73747265616d0a(.*?)0a656e6473747265616d0a', all_bytes_hex_str)
dict = {}
i = 1
for entry in res:
    dict[i] = res[i-1]
    i = i+1

array = [20, 60, 48, 46, 40, 42, 17, 44, 35, 56, 9, 45, 4, 35, 41, 19, 36, 35, 55, 21, 52, 53, 13]
for index in array:
    value = dict.get(index)
    z = zlib.decompress(bytearray.fromhex(value))
    print(chr(z[37]), end='')
```

FLAG: CSA{ke3P_caLm_4Nd_r7fM}

