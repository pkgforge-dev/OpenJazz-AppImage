#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package openjazz-git

# If the application needs to be manually built that has to be done down here
echo "Building OpenJazz..."
echo "---------------------------------------------------------------"
REPO="https://github.com/AlisterT/openjazz"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./openjazz
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./openjazz
cmake -S ./ -B build -DCMAKE_BUILD_TYPE=Release -DSDL_VERSION=3
cmake --build build -j$(nproc)
mv -v build/OpenJazz ../AppDir/bin
