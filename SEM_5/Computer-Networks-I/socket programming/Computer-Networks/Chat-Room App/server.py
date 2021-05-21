import socket
from threading import Thread

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

IP_ADDRESS = 'localhost'
PORT = 9999

server_socket.bind((IP_ADDRESS, PORT))
server_socket.listen(5)

people_list = []

print(f'[*] Listing as {IP_ADDRESS}:{PORT} ' + "\n")


def send_to_all(client_socket,client_message):
    for person_socket in people_list:
        if person_socket != client_socket:
            person_socket.send(f'{client_message}'.encode())


def handle_person(client_name, client_socket):
    client_socket.send("You are successfully Joined this Conversion".encode())
    while True:
        try:
            client_message = client_socket.recv(1024).decode()
            if client_message == 'QUIT':
                send_to_all(client_socket, f'{client_name} has left the conversion')
                people_list.remove(client_socket)
                client_socket.close()
                break
        except Exception as e:
            people_list.remove(client_socket)
            client_socket.close()
        else:
            print(client_message)
            send_to_all(client_socket, client_message)


while True:
    client_socket, addr = server_socket.accept()
    print(f'[+] {addr} connected')
    client_name = client_socket.recv(1024).decode()
    send_to_all(client_socket, f'{client_name} Joined the Conversion')
    people_list.append(client_socket)
    client_thread = Thread(target=handle_person, args=(client_name, client_socket))
    client_thread.daemon = True
    client_thread.start()

