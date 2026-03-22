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
	fetchers   []Fetcher
	pipelines  []Pipeline
	cursor     int
	listOffset int
	loading    bool
	err        error
	width      int
	height     int
}

func New(fetchers []Fetcher) Model {
	return Model{fetchers: fetchers, loading: true}
}

func (m Model) Init() tea.Cmd {
	return fetchPipelinesCmd(m.fetchers)
}

// --- Update ---
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		visibleItems := m.height - 8
		if visibleItems < 1 {
			visibleItems = 1
		}

		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
				if m.cursor < m.listOffset {
					m.listOffset = m.cursor
				}
			}
		case "down", "j":
			if m.cursor < len(m.pipelines)-1 {
				m.cursor++
				if m.cursor >= m.listOffset+visibleItems {
					m.listOffset = m.cursor - visibleItems + 1
				}
			}
		}
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
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

// --- Styles ---
var (
	successColor = lipgloss.Color("42")
	failedColor  = lipgloss.Color("196")
	runningColor = lipgloss.Color("214")
	dimColor     = lipgloss.Color("240")

	dimStyle   = lipgloss.NewStyle().Foreground(dimColor)
	titleStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("63")).MarginBottom(1).MarginLeft(1)

	paneStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(dimColor).
			Padding(1, 2)

	activePaneStyle = paneStyle.Copy().BorderForeground(lipgloss.Color("63"))
)

// --- View ---
func (m Model) View() string {
	if m.err != nil {
		return fmt.Sprintf("Error: %v\nPress q to quit.", m.err)
	}
	if m.loading {
		return " Fetching CI pipelines...\n"
	}
	if m.width == 0 {
		m.width = 100
		m.height = 30
	}

	leftWidth := (m.width * 40) / 100
	rightWidth := m.width - leftWidth - 5

	leftPane := activePaneStyle.Width(leftWidth).Height(m.height - 5).Render(m.renderList())
	rightPane := paneStyle.Width(rightWidth).Height(m.height - 5).Render(m.renderDetails())

	header := titleStyle.Render("🚀 Unified CI Dashboard")
	footer := dimStyle.Render("\n  ↑/k: up • ↓/j: down • q: quit")

	splitView := lipgloss.JoinHorizontal(lipgloss.Top, leftPane, rightPane)

	return lipgloss.JoinVertical(lipgloss.Left, header, splitView, footer)
}

func (m Model) renderList() string {
	var b strings.Builder

	visibleItems := m.height - 8
	if visibleItems < 1 {
		visibleItems = 1
	}

	end := m.listOffset + visibleItems
	if end > len(m.pipelines) {
		end = len(m.pipelines)
	}

	for i := m.listOffset; i < end; i++ {
		p := m.pipelines[i]

		icon := " "
		switch p.Status {
		case StatusSuccess:
			icon = lipgloss.NewStyle().Foreground(successColor).Render("✔")
		case StatusFailed:
			icon = lipgloss.NewStyle().Foreground(failedColor).Render("✖")
		case StatusRunning:
			icon = lipgloss.NewStyle().Foreground(runningColor).Render("↻")
		}

		cursor := "  "
		lineStyle := lipgloss.NewStyle()
		if m.cursor == i {
			cursor = "> "
			lineStyle = lineStyle.Bold(true).Foreground(lipgloss.Color("212"))
		}

		proj := p.Project
		if len(proj) > 15 {
			proj = proj[:12] + "..."
		}

		row := fmt.Sprintf("%s%s %-15s", cursor, icon, proj)
		b.WriteString(lineStyle.Render(row) + "\n")
	}
	return b.String()
}

func (m Model) renderDetails() string {
	if len(m.pipelines) == 0 {
		return dimStyle.Render("No pipelines found.")
	}

	p := m.pipelines[m.cursor]

	header := fmt.Sprintf(
		"Project: %s\nBranch:  %s\nCommit:  %s\nStatus:  %s",
		lipgloss.NewStyle().Bold(true).Render(p.Project),
		p.Branch,
		p.CommitMsg,
		string(p.Status),
	)

	var jobBoxes []string
	arrow := dimStyle.Render("  │\n  ▼")

	for _, job := range p.Jobs {
		color := dimColor
		icon := "⏳"
		switch job.Status {
		case StatusSuccess:
			color = successColor
			icon = "✔"
		case StatusFailed:
			color = failedColor
			icon = "✖"
		case StatusRunning:
			color = runningColor
			icon = "↻"
		}

		box := lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(color).
			Padding(0, 1).
			Width(25).
			Align(lipgloss.Center).
			Render(fmt.Sprintf("%s %s\n%s", icon, job.Name, dimStyle.Render(job.Time)))

		jobBoxes = append(jobBoxes, box)
	}

	graph := lipgloss.JoinVertical(lipgloss.Center, strings.Join(jobBoxes, "\n"+arrow+"\n"))

	graph = lipgloss.NewStyle().MarginTop(2).MarginLeft(2).Render(graph)

	return lipgloss.JoinVertical(lipgloss.Left, header, graph)
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
