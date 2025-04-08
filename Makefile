.PHONY: all clean certs run

all: certs build

# Generate SSL certificates
certs:
	@echo "Generating SSL certificates..."
	@mkdir -p certs
	openssl genrsa -out certs/server.key 2048
	openssl req -new -key certs/server.key -out certs/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
	openssl x509 -req -days 365 -in certs/server.csr -signkey certs/server.key -out certs/server.crt
	@echo "Certificates generated successfully"

# Build the application
build:
	@echo "Building application..."
	@mkdir -p bin 
	go build -o bin/https_server

# Run the server
run: all
	@echo "Starting HTTPS server..."
	./bin/https_server

# Clean generated files
clean:
	@echo "Cleaning up..."
	rm -f certs/server.key certs/server.csr certs/server.crt
	rm -rf certs bin
