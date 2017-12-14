#!/bin/bash
# Basic function

print() {
echo Hello $1
return 5
}

print $2
print $1

$1 $2
