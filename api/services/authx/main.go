package main

import (
	"fmt"
	"log"
	"net/http"
)

var build = "development"

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, _ = fmt.Fprintf(w, "OK - AuthX Service (Build: %s)\n", build)
}

func main() {
	http.HandleFunc("/health", healthHandler)

	log.Printf("Starting AuthX service on :8080 (Build: %s)...\n", build)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
