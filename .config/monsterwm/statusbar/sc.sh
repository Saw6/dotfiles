#!/bin/bash

if [ $(pgrep feh | wc -w) -gt 0 ]; then
kill $(pgrep feh | tail -n1) > /dev/null 2>&1;
fi
if [ $(pgrep sleep | wc -w) -gt 0 ]; then
kill $(pgrep sleep | tail -n2) > /dev/null 2>&1;
    $1 > /dev/null 2>&1
else
$1 > /dev/null 2>&1
fi
