package main

import (
	"context"
	"time"
)

type MockFetcher struct{}

func (m *MockFetcher) Name() string {
	return "Mock Provider"
}

func (m *MockFetcher) FetchRecent(ctx context.Context) ([]Pipeline, error) {
	time.Sleep(800 * time.Millisecond)

	return []Pipeline{
		{
			ID:        "run-101",
			Provider:  "GitHub",
			Project:   "my-awesome-cli",
			Branch:    "main",
			CommitMsg: "feat: add unified ci models",
			Status:    StatusSuccess,
			Duration:  2 * time.Minute,
			StartedAt: time.Now().Add(-10 * time.Minute),
			URL:       "https://github.com/user/my-awesome-cli/actions/1",
		},
		{
			ID:        "dep-404",
			Provider:  "Vercel",
			Project:   "marketing-site",
			Branch:    "fix-typo-header",
			CommitMsg: "fix: correct spelling on hero banner",
			Status:    StatusFailed,
			Duration:  45 * time.Second,
			StartedAt: time.Now().Add(-2 * time.Minute),
			URL:       "https://vercel.com/user/marketing-site/deployments/1",
		},
		{
			ID:        "run-102",
			Provider:  "GitHub",
			Project:   "backend-api",
			Branch:    "feat-auth",
			CommitMsg: "wip: working on oauth flow",
			Status:    StatusRunning,
			Duration:  3 * time.Minute,
			StartedAt: time.Now().Add(-3 * time.Minute),
			URL:       "https://github.com/user/backend-api/actions/2",
		},
	}, nil
}
