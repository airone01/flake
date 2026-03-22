package main

import "time"

type Status string

const (
	StatusPending  Status = "Pending"
	StatusRunning  Status = "Running"
	StatusSuccess  Status = "Success"
	StatusFailed   Status = "Failed"
	StatusCanceled Status = "Canceled"
)

type Pipeline struct {
	ID        string
	Provider  string
	Project   string
	Branch    string
	CommitMsg string
	Status    Status
	Duration  time.Duration
	StartedAt time.Time
	URL       string
}
