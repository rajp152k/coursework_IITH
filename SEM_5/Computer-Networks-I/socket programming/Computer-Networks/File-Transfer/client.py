import socket
import tqdm
import os
import time

# Maximum Buffer Size
BUFFER_SIZE = 1024

# IP Address and Port Number of Server
server_ip = "localhost"
server_port = 9999

# Input file need to be sent
filename = "client.txt"
file_size = os.path.getsize(filename)

# Create Socket
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Establishing Connection
print(f"[+] Connecting to {server_ip}:{server_port}")
client_socket.connect((server_ip, server_port))
print("[+] Connected")

# Send filename and file_size
client_socket.send(f"{filename}:{file_size}".encode())

# Progress bar
progress = tqdm.tqdm(range(file_size), desc=f"Sending {filename}", unit="B", unit_scale=True, unit_divisor=1024)

# Read BUFFER_SIZE byte from file and send it
with open(filename, 'rb') as f:
    for _ in range(file_size):

        # Read BUFFER_SIZE byte from file
        bytes_read = f.read(BUFFER_SIZE)

        # Update the progress bar
        progress.update(len(bytes_read))

        # Check for end of the file
        if not bytes_read:
            break

        # Send the bytes_read
        client_socket.sendall(bytes_read)

        # This sleep is added to view progress bar form 0 to 100%
        time.sleep(0.5)

client_socket.close()


