import socket
import struct
import sys

multicast_group = sys.argv[1]
server_address = ('', 10000)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

sock.bind(server_address)

group = socket.inet_aton(multicast_group)
mreq = struct.pack('4sL', group, socket.INADDR_ANY)
sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)

data, address = sock.recvfrom(1024)

print('Message : {}'.format(data.decode()))
print('Received {} byted from {}'.format(len(data), address))

sock.sendto('OK'.encode(), address)

# test on 224.3.69.71
