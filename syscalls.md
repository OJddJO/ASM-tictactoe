Here is a **syscall table** for Linux x86-64 architecture, which includes commonly used system calls. These syscalls are invoked using the `syscall` instruction, with the syscall number placed in the `rax` register and arguments passed in specific registers.

---

### **Syscall Table for Linux x86-64**

| **Syscall Number** | **Name**       | **Description**                          | **Arguments** (Registers)                     | **Return Value** (Register) |
|---------------------|----------------|------------------------------------------|-----------------------------------------------|-----------------------------|
| `0`                | `read`         | Read from a file descriptor              | `rdi`: file descriptor<br>`rsi`: buffer<br>`rdx`: count | `rax`: number of bytes read |
| `1`                | `write`        | Write to a file descriptor               | `rdi`: file descriptor<br>`rsi`: buffer<br>`rdx`: count | `rax`: number of bytes written |
| `2`                | `open`         | Open a file                              | `rdi`: filename<br>`rsi`: flags<br>`rdx`: mode | `rax`: file descriptor      |
| `3`                | `close`        | Close a file descriptor                  | `rdi`: file descriptor                        | `rax`: 0 on success         |
| `5`                | `fstat`        | Get file status                          | `rdi`: file descriptor<br>`rsi`: stat buffer  | `rax`: 0 on success         |
| `9`                | `mmap`         | Map memory                               | `rdi`: address<br>`rsi`: length<br>`rdx`: prot<br>`r10`: flags<br>`r8`: fd<br>`r9`: offset | `rax`: mapped address       |
| `10`               | `mprotect`     | Change memory protection                 | `rdi`: address<br>`rsi`: length<br>`rdx`: prot | `rax`: 0 on success         |
| `11`               | `munmap`       | Unmap memory                             | `rdi`: address<br>`rsi`: length               | `rax`: 0 on success         |
| `12`               | `brk`          | Change data segment size                 | `rdi`: address                                | `rax`: new program break    |
| `39`               | `getpid`       | Get process ID                           | None                                          | `rax`: process ID           |
| `60`               | `exit`         | Exit a process                           | `rdi`: exit code                              | Does not return             |
| `61`               | `wait4`        | Wait for a process to change state       | `rdi`: pid<br>`rsi`: status<br>`rdx`: options<br>`r10`: rusage | `rax`: PID of child         |
| `63`               | `uname`        | Get system information                   | `rdi`: utsname buffer                         | `rax`: 0 on success         |
| `78`               | `getcwd`       | Get current working directory            | `rdi`: buffer<br>`rsi`: size                  | `rax`: pointer to buffer    |
| `80`               | `chdir`        | Change current working directory         | `rdi`: path                                  | `rax`: 0 on success         |
| `87`               | `unlink`       | Delete a file                            | `rdi`: filename                               | `rax`: 0 on success         |
| `88`               | `readlink`     | Read value of a symbolic link            | `rdi`: path<br>`rsi`: buffer<br>`rdx`: size   | `rax`: number of bytes read |
| `93`               | `symlink`      | Create a symbolic link                   | `rdi`: target<br>`rsi`: linkpath              | `rax`: 0 on success         |
| `158`              | `arch_prctl`   | Set or get architecture-specific thread state | `rdi`: code<br>`rsi`: address             | `rax`: 0 on success         |
| `231`              | `exit_group`   | Exit all threads in a process            | `rdi`: exit code                              | Does not return             |

---

### **How to Use Syscalls in Assembly**
1. **Set the Syscall Number**:
   - Place the syscall number in the `rax` register.

2. **Set the Arguments**:
   - Place the arguments in the following registers:
     - `rdi`: First argument
     - `rsi`: Second argument
     - `rdx`: Third argument
     - `r10`: Fourth argument
     - `r8`: Fifth argument
     - `r9`: Sixth argument

3. **Invoke the Syscall**:
   - Use the `syscall` instruction.

4. **Check the Return Value**:
   - The return value is stored in `rax`. If an error occurs, `rax` will contain a negative value (the negated error code).

---

### **Example: Using Syscalls**

#### **1. Write to Standard Output**
```asm
section .data
    msg db "Hello, World!", 0xA
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1          ; Syscall number for write
    mov rdi, 1          ; File descriptor (stdout)
    mov rsi, msg        ; Pointer to the message
    mov rdx, msg_len    ; Length of the message
    syscall             ; Invoke the syscall

    mov rax, 60         ; Syscall number for exit
    xor rdi, rdi        ; Exit code 0
    syscall             ; Invoke the syscall
```

#### **2. Read from Standard Input**
```asm
section .bss
    buffer resb 128     ; Reserve 128 bytes for input

section .text
    global _start

_start:
    mov rax, 0          ; Syscall number for read
    mov rdi, 0          ; File descriptor (stdin)
    mov rsi, buffer     ; Pointer to the buffer
    mov rdx, 128        ; Maximum number of bytes to read
    syscall             ; Invoke the syscall

    mov rax, 60         ; Syscall number for exit
    xor rdi, rdi        ; Exit code 0
    syscall             ; Invoke the syscall
```

---

### **Notes**
- Always ensure that the arguments are valid and registers are properly set before invoking a syscall.
- Be cautious with memory addresses passed to syscalls (e.g., `rsi` for buffers). Invalid addresses can cause segmentation faults.

Let me know if you'd like further clarification or examples!