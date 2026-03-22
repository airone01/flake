package main

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// --- Messages ---
type pipelinesFetchedMsg []Pipeline
type errMsg error

// --- Enums ---
type pane int

const (
	paneList pane = iota
	paneDetails
)

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

	details viewport.Model
	ready   bool
	focus   pane
}

func New(fetchers []Fetcher) Model {
	return Model{
		fetchers: fetchers,
		loading:  true,
		focus:    paneList,
	}
}

func (m Model) Init() tea.Cmd {
	return fetchPipelinesCmd(m.fetchers)
}

// --- Update ---
func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit
		case "tab":
			if m.focus == paneList {
				m.focus = paneDetails
			} else {
				m.focus = paneList
			}
			return m, nil
		}

		if m.focus == paneList {
			switch msg.String() {
			case "up", "k":
				if m.cursor > 0 {
					m.cursor--
					if m.cursor < m.listOffset {
						m.listOffset = m.cursor
					}
					m.details.SetContent(m.renderDetails())
					m.details.GotoTop()
				}
			case "down", "j":
				if m.cursor < len(m.pipelines)-1 {
					m.cursor++
					visibleItems := m.height - 8
					if visibleItems < 1 {
						visibleItems = 1
					}
					if m.cursor >= m.listOffset+visibleItems {
						m.listOffset = m.cursor - visibleItems + 1
					}
					m.details.SetContent(m.renderDetails())
					m.details.GotoTop()
				}
			}
		} else if m.focus == paneDetails {
			var cmd tea.Cmd
			m.details, cmd = m.details.Update(msg)
			cmds = append(cmds, cmd)
		}

	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height

		leftWidth := (m.width * 40) / 100
		rightWidth := m.width - leftWidth - 5
		paneHeight := m.height - 10

		if !m.ready {
			m.details = viewport.New(rightWidth, paneHeight)
			m.ready = true
			if len(m.pipelines) > 0 {
				m.details.SetContent(m.renderDetails())
			}
		} else {
			m.details.Width = rightWidth
			m.details.Height = paneHeight
		}

	case pipelinesFetchedMsg:
		m.pipelines = msg
		m.loading = false
		if m.ready && len(m.pipelines) > 0 {
			m.details.SetContent(m.renderDetails())
		}

	case errMsg:
		m.err = msg
		m.loading = false
	}

	return m, tea.Batch(cmds...)
}

// --- Styles ---
var (
	successColor = lipgloss.Color("42")
	failedColor  = lipgloss.Color("196")
	runningColor = lipgloss.Color("214")
	dimColor     = lipgloss.Color("240")
	activeColor  = lipgloss.Color("63")

	dimStyle   = lipgloss.NewStyle().Foreground(dimColor)
	titleStyle = lipgloss.NewStyle().Bold(true).Foreground(activeColor).MarginBottom(1).MarginLeft(1)

	paneStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(dimColor).
			Padding(1, 2)
)

// --- View ---
func (m Model) View() string {
	if m.err != nil {
		return fmt.Sprintf("Error: %v\nPress q to quit.", m.err)
	}
	if m.loading || !m.ready {
		return " Fetching CI pipelines...\n"
	}

	leftWidth := (m.width * 40) / 100
	rightWidth := m.width - leftWidth - 5

	leftPaneStyle := paneStyle.Copy()
	rightPaneStyle := paneStyle.Copy()

	if m.focus == paneList {
		leftPaneStyle = leftPaneStyle.BorderForeground(activeColor)
	} else {
		rightPaneStyle = rightPaneStyle.BorderForeground(activeColor)
	}

	leftPane := leftPaneStyle.Width(leftWidth).Height(m.height - 10).Render(m.renderList())
	rightPane := rightPaneStyle.Width(rightWidth).Height(m.height - 10).Render(m.details.View())

	header := titleStyle.Render("🚀 Unified CI Dashboard")

	footerText := "  ↑/k: up • ↓/j: down • tab: switch pane • q: quit"
	if m.focus == paneDetails {
		footerText = "  ↑/k: scroll details • tab: switch pane • q: quit"
	}
	footer := dimStyle.Render("\n" + footerText)

	splitView := lipgloss.JoinHorizontal(lipgloss.Top, leftPane, rightPane)
	return lipgloss.JoinVertical(lipgloss.Left, header, splitView, footer)
}

func (m Model) renderList() string {
	var b strings.Builder

	visibleItems := m.height - 10
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
