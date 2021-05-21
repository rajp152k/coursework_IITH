import socket
import sys

SERVER_IP = sys.argv[1]
SERVER_PORT = sys.argv[2]

info = socket.getaddrinfo(SERVER_IP, SERVER_PORT, socket.AF_UNSPEC, socket.SOCK_STREAM, 0, socket.AI_PASSIVE)
address_family, socket_type, protocol, canonname,server_address = info[0]
client_socket = socket.socket(address_family, socket_type, protocol)
client_socket.connect(server_address)
print(f'Connected to {server_address}')

client_socket.send('Hello, Server'.encode())
data = client_socket.recv(1024).decode()
client_socket.close()
print(data)