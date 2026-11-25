#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Missing version argument"
    exit 1
fi

version=${1#v}
export GRAVE_RELEASE_VERSION=$version

cargo build --release --frozen --target x86_64-pc-windows-msvc
strip target/x86_64-pc-windows-msvc/release/grave_launcher.exe

mkdir -p dist

mv target/x86_64-pc-windows-msvc/release/grave_launcher dist/GraveLauncher-Windows-x86_64.exe

cargo install cargo-packager
env -u CARGO_PACKAGER_SIGN_PRIVATE_KEY cargo packager --config '{'\
'  "name": "grave-launcher",'\
'  "outDir": "./dist",'\
'  "productName": "GraveLauncher",'\
'  "version": "'"$version"'",'\
'  "identifier": "io.github.amardeeplakshkar.gravelauncher",'\
'  "resources": [],'\
'  "authors": ["Amardeep Lakshkar", "Moulberry"],'\
'  "binaries": [{ "path": "GraveLauncher-Windows-x86_64.exe", "main": true }],'\
'  "icons": ["package/windows.ico"]'\
'}'

mv -f dist/GraveLauncher-Windows-x86_64.exe dist/GraveLauncher-Windows-x86_64-Portable.exe
mv -f 'dist/GraveLauncher-Windows-x86_64_'$version'_x64-setup.exe' dist/GraveLauncher-Windows-x86_64-Setup.exe

if [[ -n "$CARGO_PACKAGER_SIGN_PRIVATE_KEY" ]]; then
    cargo packager signer sign dist/GraveLauncher-Windows-x86_64-Portable.exe

    echo "{
    \"version\": \"$version\",
    \"downloads\": {
        \"x86_64\": {
            \"executable\": {
                \"download\": \"https://github.com/amardeeplakshkar/GraveLauncher/releases/download/v$version/GraveLauncher-Windows-x86_64-Portable.exe\",
                \"size\": $(wc -c < dist/GraveLauncher-Windows-x86_64-Portable.exe),
                \"sha1\": \"$(sha1sum dist/GraveLauncher-Windows-x86_64-Portable.exe | cut -d ' ' -f 1)\",
                \"sig\": \"$(cat dist/GraveLauncher-Windows-x86_64-Portable.exe.sig)\"
            }
        }
    }
}" > dist/update_manifest_windows.json

    rm dist/*.sig
fi
