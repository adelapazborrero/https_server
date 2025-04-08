package main

import (
	"crypto/tls"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
)

const (
	defaultAddr     = ":443"
	defaultDir      = "./"
	defaultCertFile = "certs/server.crt"
	defaultKeyFile  = "certs/server.key"
)

func main() {
	// Command-line arguments
	dir := flag.String("dir", defaultDir, "The directory to serve files from")
	addr := flag.String("addr", defaultAddr, "The address to listen on (e.g., :4443 for HTTPS)")
	certFile := flag.String("cert", defaultCertFile, "Path to the SSL certificate")
	keyFile := flag.String("key", defaultKeyFile, "Path to the SSL private key")
	flag.Parse()

	// Check if certificate directory exists
	certDir := "certs"
	if _, err := os.Stat(certDir); os.IsNotExist(err) {
		log.Fatalf("Certificate directory not found. Please run 'make certs' to generate the necessary files")
	}

	// Check if certificate and key files exist
	if _, err := os.Stat(*certFile); os.IsNotExist(err) {
		log.Fatalf("Certificate file not found: %s. Please run 'make certs' to generate the necessary files", *certFile)
	}
	if _, err := os.Stat(*keyFile); os.IsNotExist(err) {
		log.Fatalf("Key file not found: %s. Please run 'make certs' to generate the necessary files", *keyFile)
	}

	// File server handler
	fileServer := http.FileServer(http.Dir(*dir))
	http.Handle("/", fileServer)

	// Configure TLS settings
	tlsConfig := &tls.Config{
		MinVersion: tls.VersionTLS12,
	}

	server := &http.Server{
		Addr:      *addr,
		Handler:   fileServer,
		TLSConfig: tlsConfig,
	}

	fmt.Printf("Serving %s via HTTPS on %s\n", *dir, *addr)

	// Start the HTTPS server
	log.Fatal(server.ListenAndServeTLS(*certFile, *keyFile))
}
