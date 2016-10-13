package main

import (
	"errors"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/neversun/Slackfish/settings"
	slack "github.com/neversun/Slackfish/slack"
	qml "gopkg.in/qml.v1"
)

const (
	Appname = "harbour-slackfish"
)

type SlackfishControl struct {
	Root     qml.Object
	Slack    *slack.Slack
	Channels *slack.Channels
	Settings *settings.Settings
	Messages *slack.Messages
}

func main() {
	if err := qml.SailfishRun(run); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(1)
	}
}

func run() error {
	cs := &slack.Channels{}
	ss := &settings.Settings{}
	ms := &slack.Messages{}
	s := &slack.Slack{}
	s.Init(ms)

	slackfish := SlackfishControl{
		Slack:    s,
		Channels: cs,
		Settings: ss,
		Messages: ms,
	}

	engine := qml.SailfishNewEngine()

	path, err := getPath()
	if err != nil {
		panic(err)
	}
	dataDir := filepath.Join(path, ".local", "share", Appname)
	set := settings.Settings{Location: filepath.Join(dataDir, "settings.yml")}
	slackfish.Settings = &set

	if err = slackfish.Settings.Load(); err != nil {
		log.Printf("WARN: %+v\n", err)
	}

	// TODO: implement translation
	// engine.Translator("/usr/share/harbour-slackfish/qml/i18n")

	context := engine.Context()
	context.SetVar("slackfishctrl", &slackfish)

	controls, err := engine.SailfishSetSource("qml/" + Appname + ".qml")
	if err != nil {
		return err
	}

	window := controls.SailfishCreateWindow()
	slackfish.Root = window.Root()

	window.SailfishShow()
	window.Wait()

	return nil
}

func getPath() (string, error) {
	path := os.Getenv("XDG_DATA_HOME")
	if len(path) == 0 {
		path = os.Getenv("HOME")
		if len(path) == 0 {
			return "", errors.New("No XDG_DATA or HOME env set!")
		}
	}
	return path, nil
}
