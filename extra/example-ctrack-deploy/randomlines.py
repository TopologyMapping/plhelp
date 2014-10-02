#!/usr/bin/python

import sys
import random

if len(sys.argv) != 4:
	sys.stdout.write('usage: %s <input> <output> <nlines>\n' % sys.argv[0])
	sys.exit(1)

inputfile, outputfile, samples = sys.argv[1:]
samples = int(samples)

lines = open(inputfile).readlines()
nlines = len(lines)
outputfile = open(outputfile, 'w')

for _i in range(samples):
	i = random.randint(0, nlines)
	line = lines[i]
	del lines[i]
	nlines -= 1
	outputfile.write(line)



