#!/usr/bin/env bash
# build-toolchain.sh
# Builds a complete x86_64-elf cross-compiler into ~/opt/cross
set -e
export PREFIX="$HOME/opt/cross"
export TARGET="x86_64-elf"
export PATH="$PREFIX/bin:$PATH"
BINUTILS_VER="2.45.1"
GCC_VER="15.3.0"
BUILD_DIR="$HOME/Desktop/cross-build"
mkdir -p "$BUILD_DIR" "$PREFIX"
cd "$BUILD_DIR"
echo "==> Downloading sources..."
wget -nc "https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.xz"
wget -nc "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.xz"
echo "==> Extracting..."
tar xf "binutils-${BINUTILS_VER}.tar.xz"
tar xf "gcc-${GCC_VER}.tar.xz"
# ── Build binutils (assembler, linker, objdump, readelf, etc.) ────────
echo "==> Building binutils..."
mkdir -p build-binutils && cd build-binutils
"../binutils-${BINUTILS_VER}/configure" \
    --target="$TARGET" \
    --prefix="$PREFIX" \
    --with-sysroot \
    --disable-nls \
    --disable-werror
make -j"$(nproc)"
make install
cd ..
# ── Build GCC (C frontend only, no standard library at all) ──────────
echo "==> Building GCC..."
mkdir -p build-gcc && cd build-gcc
"../gcc-${GCC_VER}/configure" \
    --target="$TARGET" \
    --prefix="$PREFIX" \
    --disable-nls \
    --enable-languages=c,c++ \
    --without-headers \
    --disable-hosted-libstdcxx
make -j"$(nproc)" all-gcc
make -j"$(nproc)" all-target-libgcc
make install-gcc
make install-target-libgcc
cd ..
echo ""
echo "======================================================"
echo " Cross-compiler ready!"
echo " Binaries are in: $PREFIX/bin/"
echo ""
echo " Add this line to your ~/.bashrc or ~/.zshrc:"
echo "   export PATH=\"\$HOME/opt/cross/bin:\$PATH\""
echo "======================================================"
