import socket
import tqdm
import os

# IP Address and Port Number of Server
SERVER_IP = "localhost"
SERVER_PORT = 9999

# Maximum size of Buffer
BUFFER_SIZE = 1024

# Creating a socket for server
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind IP Address and Port number to the server
server_socket.bind((SERVER_IP, SERVER_PORT))

# Start Listening
server_socket.listen(1)

print(f'[*] Listening as {SERVER_IP}:{SERVER_PORT}')


while True:

    # Accept request from the client
    client_socket, client_address = server_socket.accept()
    print(f'[+] {client_address} is connected')

    # Receive client message which contains file name and file size
    client_message = client_socket.recv(BUFFER_SIZE).decode()
    filename, file_size = client_message.split(":")

    filename = os.path.basename(filename)

    # Convert file_size to integer form string
    file_size = int(file_size)

    # Progress Bar
    progress = tqdm.tqdm(range(file_size), desc=f"Receiving {filename}", unit="B", unit_scale=True, unit_divisor=1024)

    # Save file from client in output.txt
    with open("server.txt", "wb") as f:
        for _ in range(file_size):

            # Receive message from client
            bytes_read = client_socket.recv(BUFFER_SIZE)

            # Update the progress bar
            progress.update(len(bytes_read))

            # Check end of file
            if not bytes_read:
                break

            # Write to local file
            f.write(bytes_read)

    # File transfer is done, close the connection and progress bar
    progress.close()
    client_socket.close()


