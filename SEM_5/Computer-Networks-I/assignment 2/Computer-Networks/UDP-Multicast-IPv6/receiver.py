import socket
import struct
import sys

multicast_group = sys.argv[1]

server_address = ('', 10000)

sock = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

sock.bind(server_address)

group = socket.inet_pton(socket.AF_INET6, sys.argv[1])
mreq = group + struct.pack('@I', 0)
sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_JOIN_GROUP, mreq)

data, address = sock.recvfrom(1024)

print('Message : {}'.format(data.decode()))
print('Received {} byted from {}'.format(len(data), address))

sock.sendto('OK'.encode(), address)

# test on ff15:7079:7468:6f6e:6465:6d6f:6d63:6173
