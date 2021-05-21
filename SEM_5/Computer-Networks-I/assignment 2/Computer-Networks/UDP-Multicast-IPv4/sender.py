import socket
import struct
import sys

message = 'Multicast message'
multicast_group = (sys.argv[1], 10000)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

ttl = struct.pack('b', 1)
sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, ttl)

sent = sock.sendto(message.encode(), multicast_group)

while True:
    data, server = sock.recvfrom(1024)
    print('Received Data {} from {}'.format(data.decode(),server))

print('received "{}" from {}'.format(data, server))

sock.close()

# test on 224.3.69.71
