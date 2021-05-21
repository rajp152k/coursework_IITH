#! /home/rajp152k/miniconda3/bin/python
import socket
import sys 

hostname = sys.argv[1]

try:
    resolved = socket.gethostbyname(hostname)
    print(f'the given hostname resolves to {resolved}')
except socket.gaierror:
    print(f'could not resolve the given hostname')
