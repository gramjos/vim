import socket
from jsonrpc import JSONRPCResponseManager, dispatcher
from jsonrpc.jsonrpc2 import JSONRPC20Request
import json

@dispatcher.add_method
def initialize(**kwargs):
    return {
        "capabilities": {
            "textDocumentSync": 1,
            "hoverProvider": True,
            "completionProvider": {
                "resolveProvider": True,
                "triggerCharacters": ["."]
            },
        }
    }

def main():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('localhost', 8000))
    server_socket.listen(1)
    print("Listening on port 8000...")

    while True:
        client_socket, addr = server_socket.accept()
        data = client_socket.recv(1024).decode('utf-8')
        try:
            request = json.loads(data)
            response = JSONRPCResponseManager.handle(request, dispatcher)
            client_socket.sendall(json.dumps(response.data).encode('utf-8'))
        except Exception as e:
            client_socket.sendall(f"Error: {str(e)}\n".encode('utf-8'))
        client_socket.close()

if __name__ == "__main__":
    main()
