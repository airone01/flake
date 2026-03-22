package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type GitHubFetcher struct {
	Owner string
	Repo  string
	Token string
}

func (g *GitHubFetcher) Name() string {
	return fmt.Sprintf("GitHub (%s/%s)", g.Owner, g.Repo)
}

type ghRunsResponse struct {
	WorkflowRuns []ghRun `json:"workflow_runs"`
}

type ghRun struct {
	ID           int64     `json:"id"`
	DisplayTitle string    `json:"display_title"`
	HeadBranch   string    `json:"head_branch"`
	Status       string    `json:"status"`
	Conclusion   string    `json:"conclusion"`
	HTMLURL      string    `json:"html_url"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

func (g *GitHubFetcher) FetchRecent(ctx context.Context) ([]Pipeline, error) {
	url := fmt.Sprintf("https://api.github.com/repos/%s/%s/actions/runs?per_page=10", g.Owner, g.Repo)
	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, err
	}

	req.Header.Set("Accept", "application/vnd.github.v3+json")
	if g.Token != "" {
		req.Header.Set("Authorization", "Bearer "+g.Token)
	}

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("GitHub API error: %s", resp.Status)
	}

	var result ghRunsResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, err
	}

	var pipelines []Pipeline
	for _, run := range result.WorkflowRuns {
		pipelines = append(pipelines, Pipeline{
			ID:        fmt.Sprintf("%d", run.ID),
			Provider:  "GitHub",
			Project:   g.Repo,
			Branch:    run.HeadBranch,
			CommitMsg: run.DisplayTitle,
			Status:    parseGitHubStatus(run.Status, run.Conclusion),
			Duration:  run.UpdatedAt.Sub(run.CreatedAt),
			StartedAt: run.CreatedAt,
			URL:       run.HTMLURL,
		})
	}

	return pipelines, nil
}

func parseGitHubStatus(status, conclusion string) Status {
	if status == "in_progress" {
		return StatusRunning
	}
	if status == "queued" || status == "waiting" {
		return StatusPending
	}
	if status == "completed" {
		switch conclusion {
		case "success":
			return StatusSuccess
		case "failure", "timed_out":
			return StatusFailed
		case "cancelled":
			return StatusCanceled
		default:
			return StatusPending
		}
	}
	return StatusPending
}
