# HTTPS File Server

A secure file server written in Go that serves files over HTTPS. It uses TLS 1.2+ for secure communication and supports custom directory paths and ports.

## Features

- Secure HTTPS file serving with TLS 1.2+
- Customizable directory path to serve files from
- Customizable port configuration
- Automatic SSL certificate generation
- Docker support for easy deployment

## Prerequisites

- Go 1.21 or higher
- OpenSSL (for certificate generation)

## Installation

### Building from Source

1. Clone the repository:

```bash
git clone https://github.com/adelapazborrero/https_server.git
```

2. Build the binary:

```bash
make build
```

3. Generate SSL certificates (if needed):

```bash
make certs
```

### Using Docker

Build the Docker image:

```bash
docker build -t https-server .
```

## Usage

### Command Line

Run the server with default settings:

```bash
./bin/https_server
```

Customize the server with command line flags:

```bash
./bin/https_server -dir=/path/to/files -addr=:4443 -cert=certs/server.crt -key=certs/server.key
```

Available flags:

- `-dir`: Directory to serve files from (default: "./")
- `-addr`: Address to listen on (default: ":443")
- `-cert`: Path to SSL certificate (default: "certs/server.crt")
- `-key`: Path to SSL private key (default: "certs/server.key")

### Docker

Run the server using Docker:

```bash
docker run -d -p 443:443 https-server
```

To serve files from a specific directory:

```bash
docker run -d -p 443:443 -v /path/to/files:/app https-server
```

## Certificate Generation

The server requires SSL certificates to operate. You can either:

1. Use the provided `make certs` command to generate self-signed certificates:

```bash
make certs
```

2. Provide your own certificates by placing them in the `certs` directory:

- `server.crt` - SSL certificate
- `server.key` - SSL private key

## Security

The server uses TLS 1.2+ for secure communication and supports modern cipher suites. The default configuration includes:

- TLS 1.2 minimum version
- Self-signed certificates (for development/testing)
- Customizable certificate paths
