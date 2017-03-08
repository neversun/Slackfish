package slack

import (
	"fmt"

	slackApi "github.com/nlopes/slack"
)

// API exports API of slack package
var API *slackApi.Client
var slackRtm *slackApi.RTM
var Slack = Model{}

var messageID = 0
var token string

// SlackModel represents the entity models for storing information by @API
type Model struct {
	Messages Messages
	Users    Users
	Channels Channels
	IMs      IMs
}

// Connect establishes a connection to slack API
func (s *Model) Connect(tkn string) {
	token = tkn
	API = slackApi.New(tkn)

	slackApi.SetLogger(logger)
	API.SetDebug(true)

	slackRtm = API.NewRTM()
	info, _, _ := slackRtm.StartRTM()
	s.Users.AddUsers(info.Users)
	s.Channels.AddChannels(info.Channels)
	s.IMs.AddIMs(info.IMs)

	go slackRtm.ManageConnection()

	go processEvents(s)
}

// Disconnect from slack API
func (s *Model) Disconnect() {
	err := slackRtm.Disconnect()
	if err != nil {
		errorLn(err.Error())
	}
}

func processEvents(s *Model) {
	for {
		select {
		case msg := <-slackRtm.IncomingEvents:
			fmt.Print("Event Received: ")
			switch ev := msg.Data.(type) {
			case *slackApi.HelloEvent:
				// Ignore hello

			case *slackApi.ConnectedEvent:
				fmt.Printf("Infos: %+v \n", ev.Info)
				fmt.Println("Connection counter:", ev.ConnectionCount)

			case *slackApi.MessageEvent:
				fmt.Printf("Message: %v\n", ev)
				s.Messages.Add(&ev.Msg)

			case *slackApi.PresenceChangeEvent:
				fmt.Printf("Presence Change: %v\n", ev)

			case *slackApi.LatencyReport:
				fmt.Printf("Current latency: %v\n", ev.Value)

			case *slackApi.RTMError:
				fmt.Printf("Error: %s\n", ev.Error())

			case *slackApi.InvalidAuthEvent:
				fmt.Printf("Invalid credentials")
				break

			case *slackApi.AckMessage:
				fmt.Printf("AckMessage: %+v\n", ev)
				s.Messages.MarkSent(ev.ReplyTo)

			default:

				fmt.Printf("Unexpected (%+v): %v\n", ev, msg.Data)
			}
		}
	}
}
