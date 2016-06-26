package main

import (
	"fmt"
	"os"

	qml "gopkg.in/qml.v1"
)

type SlackfishControl struct {
	Root qml.Object
}

func main() {
	fmt.Println("meow")
	if err := qml.SailfishRun(run); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func run() error {
	slackfish := SlackfishControl{}

	engine := qml.SailfishNewEngine()

	// TODO: implement translation
	// engine.Translator("/usr/share/harbour-slackfish/qml/i18n")

	// context := engine.Context()
	// context.SetVar("slackfishctrl", &slackfish)

	controls, err := engine.SailfishSetSource("qml/harbour-slackfish.qml")
	if err != nil {
		return err
	}

	window := controls.SailfishCreateWindow()
	slackfish.Root = window.Root()

	window.SailfishShow()
	window.Wait()

	return nil
}
