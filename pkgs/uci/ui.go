package main

import (
	"context"
	"fmt"
	"strings"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// --- Messages ---
type pipelinesFetchedMsg []Pipeline
type errMsg error

// --- Model ---
type Model struct {
	fetchers  []Fetcher
	pipelines []Pipeline
	cursor    int
	loading   bool
	err       error
}

func New(fetchers []Fetcher) Model {
	return Model{
		fetchers: fetchers,
		loading:  true,
	}
}

// --- Init ---
func (m Model) Init() tea.Cmd {
	return fetchPipelinesCmd(m.fetchers)
}

// --- Update ---
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}
		case "down", "j":
			if m.cursor < len(m.pipelines)-1 {
				m.cursor++
			}
		}

	case pipelinesFetchedMsg:
		m.pipelines = msg
		m.loading = false
		return m, nil

	case errMsg:
		m.err = msg
		m.loading = false
		return m, nil
	}

	return m, nil
}

// --- View ---
var (
	titleStyle   = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("63")).MarginBottom(1)
	successStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("42"))  // green
	failedStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color("196")) // red
	runningStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("214")) // yellow
	dimStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("240")) // gray
	cursorStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color("212")).Bold(true)
)

func (m Model) View() string {
	if m.err != nil {
		return fmt.Sprintf("Error: %v\n\nPress q to quit.", m.err)
	}

	if m.loading {
		return "Fetching CI pipelines... (Simulating network delay)\n"
	}

	var b strings.Builder
	b.WriteString(titleStyle.Render("🚀 Unified CI Dashboard") + "\n")

	for i, p := range m.pipelines {
		statusText := string(p.Status)
		switch p.Status {
		case StatusSuccess:
			statusText = successStyle.Render("✔ " + statusText)
		case StatusFailed:
			statusText = failedStyle.Render("✖ " + statusText)
		case StatusRunning:
			statusText = runningStyle.Render("↻ " + statusText)
		}

		cursor := "  "
		if m.cursor == i {
			cursor = cursorStyle.Render("> ")
		}

		row := fmt.Sprintf("%s %-15s │ %-15s │ %s (%s)",
			cursor,
			statusText,
			p.Project,
			p.CommitMsg,
			dimStyle.Render(p.Branch),
		)
		b.WriteString(row + "\n")
	}

	b.WriteString(dimStyle.Render("\n↑/k: up • ↓/j: down • q: quit\n"))
	return b.String()
}

// --- Commands ---
func fetchPipelinesCmd(fetchers []Fetcher) tea.Cmd {
	return func() tea.Msg {
		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()

		var all []Pipeline
		for _, f := range fetchers {
			res, err := f.FetchRecent(ctx)
			if err != nil {
				return errMsg(err)
			}
			all = append(all, res...)
		}

		return pipelinesFetchedMsg(all)
	}
}
