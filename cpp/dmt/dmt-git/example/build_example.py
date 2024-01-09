#!/usr/bin/python
import os, sys

BIN_DIR = "../bin"
INCLUDE_DIR = "../src"

os.chdir(sys.path[0])

if not os.path.exists(BIN_DIR):
  os.makedirs(BIN_DIR)

os.system(
  "gcc -Wall -I%s -o %s/example.bin ../src/*.c example.c"
  % (INCLUDE_DIR, BIN_DIR))

