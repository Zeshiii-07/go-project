package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealthHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rr := httptest.NewRecorder()

	healthHandler(rr, req)

	if rr.Code != http.StatusOK {
		t.Errorf("expected status 200 OK, got %d", rr.Code)
	}

	expected := "OK - AuthX Service (Build: development)\n"
	if rr.Body.String() != expected {
		t.Errorf("expected body %q, got %q", expected, rr.Body.String())
	}
}
