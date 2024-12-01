#!/bin/bash

# Create temp directory if it doesn't exist
mkdir -p temp

# Download NASM if not present
if [ ! -f "temp/nasm" ]; then
    echo "Downloading NASM..."
    wget https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.gz -O temp/nasm.tar.gz
    cd temp
    tar xf nasm.tar.gz
    cd nasm-2.16.01
    ./configure
    make
    cp nasm ../nasm
    cd ../..
    rm -rf temp/nasm-2.16.01 temp/nasm.tar.gz
fi

# Make NASM executable
chmod +x temp/nasm

# Compile the assembly code
echo "Compiling exploit.asm..."
./temp/nasm -f elf64 exploit.asm -o exploit.o

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

# Link the object file
echo "Linking..."
ld exploit.o -o exploit

if [ $? -ne 0 ]; then
    echo "Linking failed!"
    exit 1
fi

echo "Compilation successful! Output file: exploit"
chmod +x exploit
