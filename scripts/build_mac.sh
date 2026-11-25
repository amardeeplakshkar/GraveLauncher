#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Missing version argument"
    exit 1
fi

version=${1#v}
export GRAVE_RELEASE_VERSION=$version

cargo build --release --frozen --target aarch64-apple-darwin
cargo build --release --frozen --target x86_64-apple-darwin

strip target/aarch64-apple-darwin/release/grave_launcher
strip target/x86_64-apple-darwin/release/grave_launcher

mkdir -p dist

lipo -create -output dist/GraveLauncher-macOS-Universal target/x86_64-apple-darwin/release/grave_launcher target/aarch64-apple-darwin/release/grave_launcher

cargo install cargo-packager
env -u CARGO_PACKAGER_SIGN_PRIVATE_KEY cargo packager --config '{'\
'  "name": "grave-launcher",'\
'  "outDir": "./dist",'\
'  "formats": ["dmg", "app"],'\
'  "productName": "GraveLauncher",'\
'  "version": "'"$version"'",'\
'  "identifier": "io.github.amardeeplakshkar.gravelauncher",'\
'  "resources": [],'\
'  "authors": ["Amardeep Lakshkar", "Moulberry"],'\
'  "binaries": [{ "path": "GraveLauncher-macOS-Universal", "main": true }],'\
'  "icons": ["package/mac.icns"],'\
'  "macos": {"entitlements": "package/mac/entitlements.plist", "infoPlistPath": "package/mac/Info.plist"}'\
'}'

mv -f dist/GraveLauncher-macOS-Universal dist/GraveLauncher-macOS-Universal-Portable
mv -f dist/GraveLauncher*.dmg dist/GraveLauncher.dmg
tar -czf dist/GraveLauncher.app.tar.gz -C dist GraveLauncher.app
rm -r dist/GraveLauncher.app

if [[ -n "$CARGO_PACKAGER_SIGN_PRIVATE_KEY" ]]; then
    cargo packager signer sign dist/GraveLauncher-macOS-Universal-Portable
    cargo packager signer sign dist/GraveLauncher.dmg
    cargo packager signer sign dist/GraveLauncher.app.tar.gz

    echo "{
    \"version\": \"$version\",
    \"downloads\": {
        \"universal\": {
            \"executable\": {
                \"download\": \"https://github.com/amardeeplakshkar/GraveLauncher/releases/download/v$version/GraveLauncher-macOS-Universal-Portable\",
                \"size\": $(wc -c < dist/GraveLauncher-macOS-Universal-Portable),
                \"sha1\": \"$(sha1sum dist/GraveLauncher-macOS-Universal-Portable | cut -d ' ' -f 1)\",
                \"sig\": \"$(cat dist/GraveLauncher-macOS-Universal-Portable.sig)\"
            },
            \"app\": {
                \"download\": \"https://github.com/amardeeplakshkar/GraveLauncher/releases/download/v$version/GraveLauncher.app.tar.gz\",
                \"size\": $(wc -c < dist/GraveLauncher.app.tar.gz),
                \"sha1\": \"$(sha1sum dist/GraveLauncher.app.tar.gz | cut -d ' ' -f 1)\",
                \"sig\": \"$(cat dist/GraveLauncher.app.tar.gz.sig)\"
            }
        }
    }
}" > dist/update_manifest_macos.json

    rm dist/*.sig
fi
