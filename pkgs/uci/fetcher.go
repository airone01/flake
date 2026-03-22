package main

import "context"

type Fetcher interface {
	Name() string

	FetchRecent(ctx context.Context) ([]Pipeline, error)
}
