#!/bin/bash

#
# This is a temporary fix for the fact that swift build defaults the the current platform
# and doesn't allow an override via parameters (yet). We generate the build yaml files
# then sed them to work with our intended target.
#

# swift build --help

TARGET_IOS="armv7-apple-ios10.0"
TARGET_SIM="x86_64-apple-ios10.0"
TARGET_MAC="x86_64-apple-macosx10.10"

SDK_IOS="iPhoneOS"
SDK_SIM="iPhoneSimulator"
SDK_MAC="MacOSX"

if [ ! -f .build/debug.yaml ]; then
  swift build --configuration debug
fi

if [ ! -f .build/release.yaml ]; then
  swift build --configuration release
fi

IS_IOS=`grep -c "$TARGET_IOS" .build/debug.yaml`
IS_SIM=`grep -c "$TARGET_SIM" .build/debug.yaml`
IS_MAC=`grep -c "$TARGET_MAC" .build/debug.yaml`

if [ "$IS_IOS" -eq 1 ]; then
  TARGET_OLD=$TARGET_IOS
  SDK_OLD=$SDK_IOS
  CONFIG_OLD="ios"
elif [ "$IS_SIM" -eq 1 ]; then
  TARGET_OLD=$TARGET_SIM
  SDK_OLD=$SDK_SIM
  CONFIG_OLD="sim"
elif [ "$IS_MAC" -eq 1 ]; then
  TARGET_OLD=$TARGET_MAC
  SDK_OLD=$SDK_MAC
  CONFIG_OLD="mac"
fi

function reconfig {
  if [ "$1" == "ios" ]; then
    TARGET_NEW=$TARGET_IOS
    SDK_NEW=$SDK_IOS
  elif [ "$1" == "sim" ]; then
    TARGET_NEW=$TARGET_SIM
    SDK_NEW=$SDK_SIM
  elif [ "$1" == "mac" ]; then
    TARGET_NEW=$TARGET_MAC
    SDK_NEW=$SDK_MAC
  fi

  sed -i '' -- "s/$SDK_OLD.platform/$SDK_NEW.platform/g" .build/debug.yaml
  sed -i '' -- "s/$SDK_OLD[0-9.]*.sdk/$SDK_NEW.sdk/g" .build/debug.yaml
  sed -i '' -- "s/$TARGET_OLD/$TARGET_NEW/g" .build/debug.yaml
}

if [ "$#" -ne 2 ]; then
  echo "Requires parameters [ ios / sim / mac ] and [debug / release / clean]"
else
  if [ "$2" == "clean" ]; then
    rm -r .build
  else
    if [ "$1" != "$CONFIG_OLD" ]; then
      reconfig $1
    fi

    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-build-tool -C .build -f $2.yaml
  fi
fi

