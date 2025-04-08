# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -o https_server .

# Final stage
FROM alpine:3.19

WORKDIR /app

# Install openssl for certificate generation
RUN apk add --no-cache openssl

# Copy the binary from the builder stage
COPY --from=builder /app/https_server .

# Create certs directory if it doesn't exist
RUN mkdir -p certs

# Generate certificates if they don't exist
RUN if [ ! -f "certs/server.crt" ] || [ ! -f "certs/server.key" ]; then \
    openssl genrsa -out certs/server.key 2048 && \
    openssl req -new -key certs/server.key -out certs/server.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" && \
    openssl x509 -req -days 365 -in certs/server.csr -signkey certs/server.key -out certs/server.crt; \
fi

# Copy the default directory to serve
COPY --from=builder /app/ ./

EXPOSE 443

CMD ["./https_server"]
