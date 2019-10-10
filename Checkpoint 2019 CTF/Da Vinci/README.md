# Da Vinci Challenge Writeup

![Imgur](https://imgur.com/wO5un0w.png)

"I ordered a reproduction of a famous renaissance painting, but the artist sent me this file. Can you help?"

## Solution

This challenge had made me think a lot. </br>
We open the pcap file with Wireshark, and discover it contains USB device traffic compliant to the USB protocol.</br>
After a bit of looking inside the packets, we see the device is a Wacom of model [CTL-471](https://www.amazon.com/Wacom-Bamboo-CTL471-Tablet-Black/dp/B00EVOXM3S).</br>
Analyzing USB traffic is a new area for me, and I had to do the research to understand the traffic.</br>
Here are few links which helped me understand the protocol:</br>
https://medium.com/@ali.bawazeeer/kaizen-ctf-2018-reverse-engineer-usb-keystrok-from-pcap-file-2412351679f4</br>
https://wiki.wireshark.org/USB?source=post_page</br>
https://www.usb.org/sites/default/files/documents/hut1_12v2.pdf</br>
https://www.usb.org/sites/default/files/documents/hid1_11.pdf (the best)</br>
</br>
Few more insights after understanding the USB protocol:
- according to GET DESCRIPTOR Response CONFIGURATION message, the device has multiple endpoint desriptors, when one of them is defined as HID Mouse:</br>
![](https://snag.gy/imkxKw.jpg)
- frames 1-35 are configuration frames between the host and the device, and frame 36 and onwards are interrupt frames from the device. each frame is triggered by the device with new information (probably the mouse location).
- the interrupt frames has no information about the location/extra HID data, except 4 bytes at the end of the frame which are names "Leftover Capture Data" in Wireshark.</br>
![](https://snag.gy/TBndiq.jpg)
- Most of the interrupt frames has 4 byte leftover data, except number of frames with weird long leftover data (9 bytes):</br>
![](https://snag.gy/hnSm8C.jpg)</br>

Lets try to analyze that:
- lets ignore for now of the long constant data.
- if we analyze the 4 bytes we have:
  - byte 0 - constant `0x01`
  - byte 1 - constant `0x80` with sometimes the LSB on makes it `0x81` (probably indicates mouse clicks)
  - byte 2 - varying number
  - byte 3 - varying number
- I tried to understand the meaning of the varying number by translating it to integer, float, or trating the whole 4 bytes as signed/unsigned integer without success.
Finally, one of the attached documents above indicates that mouse data is passed by two bytes - x and y, when each is in range of -128 to 127.</br>
In addition, it says that the origin of axis is at the top/left corner, and that data is relative data.</br>
From that point I created a small python program which reads all the frames using scapy, converts the coordinates to absolute coordinates, and draw on a graph using matplotlib.</br>
Code:</br>
```python
from scapy.all import *
import binascii
import struct
import numpy as np
import matplotlib.pyplot as plt

packets = rdpcap('davinci.pcap')

absolute_x = 200 # arbitrary value
absolute_y = 200 # arbitrary value
points = []

for i in range(35, len(packets)):
    packet = raw(packets[i])[27:] # leftover data
    if len(packet) != 4: # ignore long data
        continue
    relative_x = packet[2] # x
    relative_y = packet[3] # y
    if relative_x > 127: # making is signed
        relative_x = (256 - relative_x) * -1
    if relative_y > 127: # making is signed
        relative_y = (256 - relative_y) * -1
    relative_y = relative_y * -1 # because axis is on top left and not bot left.
    absolute_x = absolute_x + relative_x
    absolute_y = absolute_y + relative_y
    points.append([absolute_x, absolute_y])

data = np.array(points)
absolute_x, absolute_y = data.T
plt.scatter(absolute_x, absolute_y)
plt.show()
```
Running the program will give me the next result:</br>
![](https://snag.gy/BnKDMT.jpg)
Probably I could research more, and find how to know when mouse is clicked, but it was enough for me to discover the flag from there (when you zoom in you can see characters more clearly).

FLAG = CSA{Ju5T_Lik3_Leon4rdO_d4_ViNc1}



