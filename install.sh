#!/bin/bash

if [ "$#" -ne "2" ]; then
  echo "Usage: install.sh <objc:swift> <destination path>>"
  exit
fi

if [ "$1" == "objc" ]; then
  echo $1
  mkdir -p "$2"
  tar cf - --exclude=.git -C ObjcTemplate . | (cd "$2" && tar xvf - )
fi

if [ "$1" == "swift" ]; then
  echo $1
  mkdir -p "$2"
  tar cf - --exclude=.git -C SwiftTemplate . | (cd "$2" && tar xvf - )
fi
