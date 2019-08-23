# Satellite Writeup - networking

Placing your ship in range of the Osmiums, you begin to receive signals. Hoping that you are not detected, because it's too late now, you figure that it may be worth finding out what these signals mean and what information might be "borrowed" from them. Can you hear me Captain Tim? Floating in your tin can there? Your tin can has a wire to ground control?

Find something to do that isn't staring at the Blue Planet.

## Solution

We downloading two files:

- `README.pdf` file which contains picture of a satellite.
- and `init_sat` which is ELF file of the satellite.

when we running the ELF we getting:

```bash
alex@desktop:/mnt/d/Projects/github-ctfs/CTFs/Google CTF 2019/Beginners/Satellite$ ./init_sat
Hello Operator. Ready to connect to a satellite?
Enter the name of the satellite to connect to or 'exit' to quit
```

we try to insert the name which was written in the PDF file: osmium and we get more options:

```bash
osmium
Establishing secure connection to osmium
 satellite...
Welcome. Enter (a) to display config data, (b) to erase all data or (c) to disconnect
```

we try to input option 'a' and option 'b':

```bash
a
Username: brewtoot password: ********************       166.00 IS-19 2019/05/09 00:00:00        Swath 640km     Revisit capacity twice daily, anywhere Resolution panchromatic: 30cm multispectral: 1.2m      Daily acquisition capacity: 220,000km²  Remaining config data written to: https://docs.google.com/document/d/14eYPluD_pi3824GAFanS29tWdTcKxP_XUxx7e303-3E

b
Insufficient privileges.
```

As we see option 'a' is pretty interesting. we hava blacked password which we will need to hack, and we get external link which we need to download.</br>
The link provides us this string: `VXNlcm5hbWU6IHdpcmVzaGFyay1yb2NrcwpQYXNzd29yZDogc3RhcnQtc25pZmZpbmchCg==`. This appears as base64 encoded. lets try to decode it:

```bash
alex@desktop:/mnt/d/Projects/github-ctfs/CTFs/Google CTF 2019/Beginners/Satellite$ echo VXNlcm5hbWU6IHdpcmVzaGFyay1yb2NrcwpQYXNzd29yZDogc3RhcnQtc25pZmZpbmchCg== | base64 -d
Username: wireshark-rocks
Password: start-sniffing!
```

We get clear hint we should use wireshark !</br>
Lets put wireshark on while we connect to the satellite to capture some traffic (we also turn off as much network programs as we can).</br>
When we run the `init_sat` and send it the input we observe this connection on wireshark:</br>
![](https://snipboard.io/rtnYxz.jpg)
If we follow tcp stream we get:</br>
![](https://i.imgur.com/WzThxYe.png)

flag - CTF{4efcc72090af28fd33a2118985541f92e793477f}
