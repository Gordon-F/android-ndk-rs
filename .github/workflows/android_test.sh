#!/bin/sh

set -ex

rustup target install x86_64-linux-android
cargo install cargo-apk
cd "$GITHUB_WORKSPACE/ndk-examples"
cargo apk run --example hello_world --target x86_64-linux-android

sleep 30s

adb logcat *:E RustStdoutStderr:V -d > ~/logcat.log

if grep 'RustStdoutStderr' ~/logcat.log;
then
    echo "App running"
else
    exit 1
fi

if grep -e 'thread.*panicked at' ~/logcat.log;
then
    exit 1
else
    exit 0
fi
