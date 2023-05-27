Lecture notes on security engineering, part 2: Programs and processes
Michael Sjöberg
Aug 28, 2022
May 27, 2023

## <a name="1" class="anchor"></a> [File permissions](#1)

In UNIX-based systems, a process has real UID/GID, which is the user who started or own the process, effective UID/GID, which is referred to as EUID and used to determine permissions, and saved UID/GID, which is referred to as SUID and used to drop and gain privileges. A program with the SUID bit set has the effective UID/GID changed to that of the program owner.

File permissions are set using command, such as `-rwxr-xr-x root root <file>`:

- `rwx`, or read-write-execute, is first root (file owner)
- first ``r-x``, or read-execute, is second root (group owner)
- second ``r-x`` is all others

The kernel will check EUID when the user is trying to write to file (root user id is 0), so changing EUID, `chmod 4755 <file>`, which replaces ``rwx`` with ``rws``, can make it writable to other users (fixed effective user id for file).

## <a name="2" class="anchor"></a> [Address space](#2)

An address space is the range of addresses available to some process.

```c
int z;
int w = 10;
int main() {
    int x;
    int y = 42;
    char *p;
    p = malloc(42);
    *p = 42;
}
```

Below are the locations in buffer (address space is based on Linux legacy VM layout).

|     |     |
| :-- | --- |
| | user space ~3GB |
| `.text` for program code | |
| `.bss` for uninitialized global data | `z` |
| `.data` for initialized global data | `w` |
| heap (growing from lower to higher addresses) | `malloc(42)` |
| memory mapped region for large chunks of memory, such as shared libraries (text, data, `printf`) | |
| stack (growing from higher to lower addresses) | `x` |
| | `y`  |
| | `*p` |
| | `p` (points to address in heap) |
| | `*p = 42` (write 42 in address in heap) |
| | kernel space ~1GB |

## <a name="3" class="anchor"></a> [Application-level vulnerabilities](#3)

Vulnerabilities in applications are often due to deployment of overprivileged applications, such as mobile applications asking for all permissions or when applications are writable instead of only readable, and implementation issues with unexpected inputs or errors:

- local attacks need an established presence on host, such as account or application controlled by attacker, would allow executing operations with superior privileges, and is easier to perform (better knowledge of environment)
- remote attacks involve manipulation of an application via network-based interaction, unauthenticated, which means there is no need for authentication or permission, would allow executing operations with privileges of the vulnerable application, and is more difficult to perform (but more powerful, no need to require prior access to system).

Most local attacks exploit vulnerabilities in SUID-root programs to obtain root privileges. Bad inputs can be supplied at startup via command line and environment, or during execution via dynamic-linked objects and files. Unintended interaction with environment can result in creation of new files, accessing files via file system, or invoking commands and processes. Local attacks often result in memory corruption (control hijacking, data brainwashing), command injection, and information leaks.

#### Environment attacks

An environment attack can occur when applications invoke external commands to carry out tasks, such as `system()` to execute some command, `popen()` to open a process, or `execlp()` and `execvp()` to use the `PATH` environment variable to locate applications. A `PATH` substitution attack use commands without a complete path, where attacker modifies the `PATH` variable to run script, or the `HOME` variable to control execution of commands, such as accessing files.

#### Input argument attacks

An input argument attack can occur when applications are supplied arguments via the command-line (this also applies to web applications and databases), where user-provided inputs can be used to inject commands, such as `./program "; rm -rf /"`, which would call `program` and then inject command to delete everything, traverse directories (dot-dot attack), overflow buffer, and perform format string attacks:

- always check size to avoid overflow, such as when copied into buffers (`snprintf` limits size to `n`)
- always sanitize user-provided input to avoid bad formats, such as excluding known bad inputs, define allowed input, or escaping special characters

#### File access attacks

A file access attack can occur when applications create and use files: 

- always check that file exist (and is not symbolic link)
- [race conditions](https://en.wikipedia.org/wiki/Race_condition), such as [time-of-check to time-of-use (TOCTTOU)](https://en.wikipedia.org/wiki/Time-of-check_to_time-of-use), can occur when there is conflicting access to shared data by multiple processes, where at least one has write access

    ```c
    // `access()` checks real UID and `open()` checks effective UID

    /* real UID */
    if (access("file", W_OK) == 0) {
        /* symlink("/etc/passwd", "file"); */
        
        /* effective UID */
        if((f = open("file", O_WRONLY)) < 0) {
            /* ... */
        }
        /* potentially writing to "/etc/passwd" */
        write(f, buffer, count);
    }
    ```

#### Buffer overflow attacks

A buffer overflow attack can occur when programs try to store more elements in a buffer (set of memory locations) than it can contain. Systems can sometimes detect and block potential overflows, such as in Java, and others do not detect, in which case the operation is executed (it is not detected in C by default).

Below is an example program that is vulnerable to the buffer overflow attack (executing this would result in overflow of `buffer_1` into `buffer_2`).
    
```c
int main() {
    int i;
    char buffer_2[4];
    char buffer_1[6];

    for(i=0; i < 10; i++) {
        buffer_1[i] = 'A';
    }

    return 0;
}
```

#### [Next part](lecture-notes-on-security-engineering-part-3)

