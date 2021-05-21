import socket
from datetime import  datetime
from threading import Thread
import sys
from colorama import Fore, init, Back
import random

init()

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

SERVER_IP_ADDRESS = 'localhost'
SERVER_PORT = 9999

print(f'[+] Connecting to {SERVER_IP_ADDRESS}:{SERVER_PORT}')
client_socket.connect((SERVER_IP_ADDRESS, SERVER_PORT))
print(f'[+] Connected')


colors = [Fore.BLUE, Fore.CYAN,
    Fore.LIGHTBLUE_EX, Fore.LIGHTCYAN_EX,
    Fore.LIGHTMAGENTA_EX, Fore.LIGHTRED_EX,
    Fore.LIGHTYELLOW_EX, Fore.MAGENTA, Fore.RED, Fore.WHITE, Fore.YELLOW
]

mycolor = random.choice(colors)
time_color = Fore.LIGHTGREEN_EX


def receive():
    while True:
        message = client_socket.recv(1024).decode()
        print("\n" + message)


receive_thread = Thread(target=receive)
receive_thread.daemon = True
receive_thread.start()

client_socket.send(sys.argv[1].encode())

while True:
    message = input(Fore.LIGHTGREEN_EX)
    if message == 'QUIT':
        print()
        client_socket.send(message.encode())
        break
    curr_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    message_to_sent = f'{time_color}[{curr_time}] {sys.argv[1]}: {Fore.RESET}{mycolor}{message}{Fore.RESET}'
    client_socket.send(message_to_sent.encode())
    if message == 'QUIT':
        break


client_socket.close()
