# Compiler and Interpreter Project

This project implements both a compiler and interpreter for a simple programming language, demonstrating various programming constructs and their implementations. The project uses several industry-standard tools for lexical analysis, parsing, and code generation.

## Tools Used

1. **Flex (Lexical Analyzer)**
   - Used in `lexer.l` files
   - Performs lexical analysis
   - Breaks down input code into tokens
   - Tool Command: `flex`

2. **Bison (Parser Generator)**
   - Used in `parser.y` files
   - Generates parsers for grammar
   - Creates syntax trees
   - Tool Command: `bison`

3. **NASM (Assembler)**
   - Used for assembly code generation
   - Target for compiler output
   - Files with `.asm` extension

4. **GCC (GNU Compiler Collection)**
   - Used for compiling C code
   - Links object files
   - Used in Makefiles

## Project Structure

The project is organized into several modules, each implementing different programming constructs:

### Basic Components
- **A simple example/**
  - Basic implementation of compiler and interpreter
  - Contains both IR (Intermediate Representation) and Code Generation examples

### Control Structures
1. **Basic if while/**
   - Implementation of basic control structures
   - Separate compiler and interpreter versions

2. **Nested if else/**
   - Complex conditional statements
   - Nested if-else implementation

3. **For loop/**
   - For loop implementation
   - Both compiler and interpreter versions

4. **Do while loop/**
   - Do-while loop implementation
   - Demonstrates loop control structures

5. **Continue break/**
   - Implementation of loop control statements
   - Break and continue functionality

### Common Components in Each Module

Each module typically contains:
- `lexer.l`: Lexical analyzer definitions
- `parser.y`: Grammar rules and parsing logic
- `codeGen.c/h`: Code generation implementation
- `symtab.c/h`: Symbol table management
- `Makefile`: Build automation
- `input.txt`: Sample input files
- `output.txt`: Generated output
- `prog.asm`: Generated assembly code (for compiler versions)

## Building and Running

### Prerequisites
- Flex (Fast Lexical Analyzer)
- Bison (Parser Generator)
- GCC (GNU Compiler Collection)
- NASM (for compiler versions)

### Building
Each module can be built using its respective Makefile:

```bash
cd <module_directory>
make
```

### Running
1. For Interpreter:
```bash
./a.exe < input.txt
```

2. For Compiler:
```bash
./a.exe < input.txt
nasm -f win32 prog.asm  # For Windows
nasm -f elf32 prog.asm  # For Linux
```

## Features Implemented

1. Basic Arithmetic Operations
2. Variable Declarations
3. Control Structures:
   - If-else statements
   - While loops
   - For loops
   - Do-while loops
4. Nested Control Structures
5. Break and Continue Statements

## Sample Assembly Code
The `Some ASM Codes/` directory contains example assembly programs demonstrating various features:
- Basic arithmetic
- Control flow
- Memory operations
- I/O operations

## Development Notes

- Symbol table implementation uses a hash table for efficient lookup
- Code generation produces NASM-compatible assembly
- Interpreter executes code directly without generating assembly
- Error handling implemented for common syntax and semantic errors

## Contributing

Feel free to contribute to this project by:
1. Implementing new language features
2. Improving error handling
3. Optimizing code generation
4. Adding more test cases

## License

This project is open source and available under the MIT License. 
