import socket
import struct
import sys

message = 'Multicast message'
multicast_group = (sys.argv[1], 10000)

sock = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)

ttl = struct.pack('@i', 1)
sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_MULTICAST_HOPS, ttl)

sent = sock.sendto(message.encode(), multicast_group)

while True:
    data, server = sock.recvfrom(1024)
    print('Received Data {} from {}'.format(data.decode(),server))

print('received "{}" from {}'.format(data, server))

sock.close()

# test on ff15:7079:7468:6f6e:6465:6d6f:6d63:6173
