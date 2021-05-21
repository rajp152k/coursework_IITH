import socket
import sys

SERVER_IP = sys.argv[1]
SERVER_PORT = sys.argv[2]


info = socket.getaddrinfo(SERVER_IP, SERVER_PORT, socket.AF_UNSPEC, socket.SOCK_STREAM, 0, socket.AI_PASSIVE)
address_family, socket_type, protocol, canonname,server_address = info[0]
server_socket = socket.socket(address_family, socket_type, protocol)
server_socket.bind(server_address)
server_socket.listen(2)

print(f'[*] Listening as {server_address}')

while True:
    client_socket, addr = server_socket.accept()
    print('Connected to', addr)
    message = client_socket.recv(1024).decode()
    print(message)
    client_socket.send(message.encode())


