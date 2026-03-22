package main

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
)

func main() {
	ghToken := os.Getenv("GITHUB_TOKEN")

	fetchers := []Fetcher{
		&GitHubFetcher{
			Owner: "nixos",
			Repo:  "nixpkgs",
			Token: ghToken,
		},
	}

	m := New(fetchers)

	p := tea.NewProgram(m, tea.WithAltScreen())
	if _, err := p.Run(); err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	}
}
