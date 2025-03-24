# Makefile for ASM project

# Compiler
ASM = nasm

# Linker
LD = ld

# Compiler flags
ASMFLAGS = -f elf64

# Linker flags
LDFLAGS =

# Source files
SRC = $(wildcard src/*.asm)

# Object files
OBJ = $(subst src, build, $(patsubst %.asm, %.o, $(SRC)))

# Executable
TARGET = tictactoe

# Default target
all: $(TARGET)

# Link object files to create the executable
$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o bin/$@ $^
#strip bin/$@

# Compile assembly files to object files
build/%.o: src/%.asm
	$(ASM) $(ASMFLAGS) src/$*.asm -o build/$*.o

# Clean up generated files
clean:
	rm -f $(subst build/, build\, $(OBJ))

# Remake the project
remake: clean all