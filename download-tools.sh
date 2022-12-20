#!/bin/sh
set -e

rm -rf tools/gdb
rm -rf tools/djgpp
rm -rf tools/dosbox-x
rm -rf "tools/Visual Studio Code.app"
rm -rf "tools/code"
rm -rf "tools/code.exe"

base_url="https://marioslab.io/dump/dos"
gdb_url=""
djgpp_url=""
dosbox_url=""
os=$OSTYPE

if [[ "$os" == "linux-gnu"* ]]; then
    gdb_url="$base_url/gdb/gdb-7.1a-djgpp-linux.zip"
    djgpp_url="$base_url/djgpp/djgpp-linux64-gcc1210.tar.bz2"
    dosbox_url="$base_url/dosbox-x/dosbox-x-0.84.4-linux.zip"
    vscode_url="$base_url/vscode/code-stable-x64-1671533708.tar.gz"
elif [[ "$os" == "darwin"* ]]; then
    gdb_url="$base_url/gdb/gdb-7.1a-djgpp-macos-x86_64.zip"
    djgpp_url="$base_url/djgpp/djgpp-osx-gcc1210.tar.bz2"
    dosbox_url="$base_url/dosbox-x/dosbox-x-0.84.4-macos.zip"
elif [[ "$os" == "cygwin" ]] || [[ "$os" == "msys" ]] || [[ $(uname -r) =~ WSL ]]; then
    gdb_url="$base_url/gdb/gdb-7.1a-djgpp-macos-x86_64.zip"
    djgpp_url="$base_url/djgpp/djgpp-mingw-gcc1210-standalone.zip"
    dosbox_url="$base_url/dosbox-x/dosbox-x-0.84.4-windows.zip"
else
    echo "Sorry, this template doesn't support $os"
    exit
fi

pushd tools &> /dev/null

echo "Installing GDB"
echo "$gdb_url"
mkdir -p gdb
pushd gdb &> /dev/null
curl $gdb_url --output gdb.zip &> /dev/null
unzip -o gdb.zip > /dev/null
rm gdb.zip > /dev/null
popd &> /dev/null

echo "Installing DJGPP"
echo "$djgpp_url"
if [[ "$os" == "cygwin" ]] || [[ "$os" == "msys" ]] || [[ $(uname -r) =~ WSL ]]; then
    curl $djgpp_url --output djgpp.zip &> /dev/null
    unzip djgpp.zip
    rm djgpp.zip
else
    curl $djgpp_url --output djgpp.tar.bz2 &> /dev/null
    tar xf djgpp.tar.bz2
    rm djgpp.tar.bz2
fi

echo "Installing DOSBox-x"
echo "$dosbox_url"
curl $dosbox_url --output dosbox.zip &> /dev/null
unzip -o dosbox.zip &> /dev/null
rm dosbox.zip

echo "Installing VS Code extensions"
code --install-extension llvm-vs-code-extensions.vscode-clangd
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-vscode.cpptools
code --install-extension webfreak.debug

if [[ "$os" == "linux-gnu"* ]]; then
    chmod a+x gdb/gdb > /dev/null
elif [[ "$os" == "darwin"* ]]; then
    chmod a+x gdb/gdb > /dev/null
    chmod a+x dosbox-x/dosbox-x.app/Contents/MacOS/dosbox-x
    ln -s $(pwd)/dosbox-x/dosbox-x.app/Contents/MacOS/dosbox-x dosbox-x/dosbox-x
elif [[ "$os" == "cygwin" ]] || [[ "$os" == "msys" ]] || [[ $(uname -r) =~ WSL ]]; then
fi

popd &> /dev/null