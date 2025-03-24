### General-Purpose Registers in x86-64 Assembly

| **Register** | **64-bit** | **32-bit** | **16-bit** | **8-bit (High)** | **8-bit (Low)** | **Purpose**                                                                 |
|--------------|------------|------------|------------|------------------|-----------------|-----------------------------------------------------------------------------|
| **RAX**      | `rax`      | `eax`      | `ax`       | `ah`             | `al`            | Accumulator register (used for arithmetic and system calls).               |
| **RBX**      | `rbx`      | `ebx`      | `bx`       | `bh`             | `bl`            | Base register (general-purpose).                                           |
| **RCX**      | `rcx`      | `ecx`      | `cx`       | `ch`             | `cl`            | Counter register (used for loops and string operations).                   |
| **RDX**      | `rdx`      | `edx`      | `dx`       | `dh`             | `dl`            | Data register (used for I/O and arithmetic).                               |
| **RSI**      | `rsi`      | `esi`      | `si`       | -                | `sil`           | Source index register (used for string and memory operations).             |
| **RDI**      | `rdi`      | `edi`      | `di`       | -                | `dil`           | Destination index register (used for string and memory operations).        |
| **RBP**      | `rbp`      | `ebp`      | `bp`       | -                | `bpl`           | Base pointer register (used to reference function stack frames).           |
| **RSP**      | `rsp`      | `esp`      | `sp`       | -                | `spl`           | Stack pointer register (points to the top of the stack).                   |
| **R8**       | `r8`       | `r8d`      | `r8w`      | -                | `r8b`           | General-purpose register (additional in x86-64).                           |
| **R9**       | `r9`       | `r9d`      | `r9w`      | -                | `r9b`           | General-purpose register (additional in x86-64).                           |
| **R10**      | `r10`      | `r10d`     | `r10w`     | -                | `r10b`          | General-purpose register (additional in x86-64).                           |
| **R11**      | `r11`      | `r11d`     | `r11w`     | -                | `r11b`          | General-purpose register (additional in x86-64).                           |
| **R12**      | `r12`      | `r12d`     | `r12w`     | -                | `r12b`          | General-purpose register (additional in x86-64).                           |
| **R13**      | `r13`      | `r13d`     | `r13w`     | -                | `r13b`          | General-purpose register (additional in x86-64).                           |
| **R14**      | `r14`      | `r14d`     | `r14w`     | -                | `r14b`          | General-purpose register (additional in x86-64).                           |
| **R15**      | `r15`      | `r15d`     | `r15w`     | -                | `r15b`          | General-purpose register (additional in x86-64).                           |

---

### **Segment Registers**
These registers are used for segment-based memory addressing (mostly legacy in x86-64).

| **Register** | **Purpose**                                                                 |
|--------------|-----------------------------------------------------------------------------|
| `cs`         | Code segment (points to the segment containing the code).                  |
| `ds`         | Data segment (points to the segment containing data).                      |
| `ss`         | Stack segment (points to the segment containing the stack).                |
| `es`         | Extra segment (used for string operations).                                |
| `fs`         | General-purpose segment register (used for thread-local storage).          |
| `gs`         | General-purpose segment register (used for thread-local storage).          |

---

### **Special-Purpose Registers**
These registers are used for specific tasks like control, flags, and instruction pointers.

| **Register** | **Purpose**                                                                 |
|--------------|-----------------------------------------------------------------------------|
| `rip`        | Instruction pointer (points to the next instruction to execute).           |
| `eflags`     | Flags register (stores status flags like Zero Flag, Carry Flag, etc.).     |
| `rflags`     | 64-bit version of `eflags`.                                                |
| `cr0`–`cr4`  | Control registers (used for system-level tasks like enabling paging).      |
| `xcr0`       | Extended control register (used for enabling AVX and other features).      |
| `dr0`–`dr7`  | Debug registers (used for hardware breakpoints).                           |

---

### **Floating-Point and SIMD Registers**
These registers are used for floating-point operations, vector processing, and SIMD instructions.

| **Register** | **Purpose**                                                                 |
|--------------|-----------------------------------------------------------------------------|
| `st(0)`–`st(7)` | Floating-point stack registers (used for x87 FPU operations).           |
| `mm0`–`mm7`  | MMX registers (used for integer SIMD operations).                          |
| `xmm0`–`xmm15` | 128-bit SIMD registers (used for SSE instructions).                      |
| `ymm0`–`ymm15` | 256-bit SIMD registers (used for AVX instructions).                      |
| `zmm0`–`zmm31` | 512-bit SIMD registers (used for AVX-512 instructions).                  |
| `mxcsr`      | Control and status register for SIMD operations.                           |

---

### **Flags in `rflags`/`eflags`**
These flags are updated by arithmetic and logical operations.

| **Flag**      | **Bit** | **Purpose**                                                                 |
|---------------|---------|-----------------------------------------------------------------------------|
| `CF` (Carry)  | 0       | Set if an arithmetic operation generates a carry or borrow.                |
| `PF` (Parity) | 2       | Set if the number of set bits in the result is even.                       |
| `ZF` (Zero)   | 6       | Set if the result of an operation is zero.                                 |
| `SF` (Sign)   | 7       | Set if the result of an operation is negative.                             |
| `OF` (Overflow)| 11     | Set if an arithmetic operation overflows.                                  |
| `DF` (Direction)| 10    | Determines the direction for string operations (`0` = increment, `1` = decrement). |

---

### **Summary**
This table provides a complete overview of the registers available in x86-64 architecture, categorized by their purpose. Let me know if you'd like further clarification or examples of how to use specific registers!