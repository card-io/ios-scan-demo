#!/bin/sh

GitRoot="`dirname \"$0\"`"

case "$1" in
  ignore)
    git update-index --assume-unchanged ScanExample/Constants.h
  ;;
  unignore)
    git update-index --no-assume-unchanged ScanExample/Constants.h
  ;;
  *)
    echo "Usage: `basename $0` { ignore | unignore }"
  ;;
esac

