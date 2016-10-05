#!/bin/bash

#
# This is a temporary fix for the fact that swift build defaults the the current platform
# and doesn't allow an override via parameters (yet). We generate the build yaml files
# then sed them to work with our intended target.
#

# swift build --help

TARGET_IOS="armv7-apple-ios10.0"
TARGET_SIM="x86_64-apple-ios10.0"
TARGET_MACOS="x86_64-apple-macosx10.10"

SDK_IOS="iPhoneOS"
SDK_SIM="iPhoneSimulator"
SDK_MACOS="MacOSX"

TARGET_OLD=$TARGET_MACOS
SDK_OLD=$SDK_MACOS

TARGET_NEW=$TARGET_SIM
SDK_NEW=$SDK_SIM

if [ ! -f .build/debug.yaml ]; then
  swift build --configuration debug
  sed -i '' -- "s/$SDK_OLD.platform/$SDK_NEW.platform/g" .build/debug.yaml
  sed -i '' -- "s/$SDK_OLD[0-9.]*.sdk/$SDK_NEW.sdk/g" .build/debug.yaml
  sed -i '' -- "s/$TARGET_OLD/$TARGET_NEW/g" .build/debug.yaml
fi

if [ ! -f .build/release.yaml ]; then
  swift build --configuration release
  sed -i '' -- "s/$SDK_OLD.platform/$SDK_NEW.platform/g" .build/release.yaml
  sed -i '' -- "s/$SDK_OLD[0-9.]*.sdk/$SDK_NEW.sdk/g" .build/release.yaml
  sed -i '' -- "s/$TARGET_OLD/$TARGET_NEW/g" .build/release.yaml
fi

if [ "$#" -ne 1 ]; then
  echo "Requires parameter [debug / release / clean]"
else
  if [ "$1" == "clean" ]; then
    rm -r .build
  else
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-build-tool -C .build -f $1.yaml
  fi
fi

