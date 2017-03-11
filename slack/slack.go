package slack

import (
	"fmt"

	slackApi "github.com/nlopes/slack"
)

// API exports API of slack package
var API *slackApi.Client
var slackRtm *slackApi.RTM

// Slack exports all initialized models
var Slack = Model{}

var messageID = 0
var token string

// Model represents the entity models for storing information by @API
type Model struct {
	Messages Messages
	Users    Users
	Channels Channels
	IMs      IMs
}

// Connect establishes a connection to slack API
func (m *Model) Connect(tkn string) {
	token = tkn
	API = slackApi.New(tkn)

	slackApi.SetLogger(logger)
	API.SetDebug(true)

	slackRtm = API.NewRTM()
	info, _, _ := slackRtm.StartRTM()
	m.Users.AddUsers(info.Users)
	m.Channels.AddChannels(info.Channels)
	m.IMs.AddIMs(info.IMs)

	go slackRtm.ManageConnection()

	go processEvents(m)
}

// Disconnect from slack API
func (m *Model) Disconnect() {
	err := slackRtm.Disconnect()
	if err != nil {
		errorLn(err.Error())
	}
}

func processEvents(m *Model) {
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
				m.Messages.Add(&ev.Msg)

			case *slackApi.PresenceChangeEvent:
				fmt.Printf("Presence Change: %v\n", ev)
				kv := make(map[string]interface{})
				kv["presence"] = ev.Presence
				ok := m.Users.set(ev.User, kv)
				if ok != nil {
					errorLn(ok)
				}

			case *slackApi.LatencyReport:
				fmt.Printf("Current latency: %v\n", ev.Value)

			case *slackApi.RTMError:
				fmt.Printf("Error: %s\n", ev.Error())

			case *slackApi.InvalidAuthEvent:
				fmt.Printf("Invalid credentials")
				break

			case *slackApi.AckMessage:
				fmt.Printf("AckMessage: %+v\n", ev)
				m.Messages.MarkSent(ev.ReplyTo)
				break

			case *slackApi.UserTypingEvent:
				fmt.Printf("UserTypingEvent: %+v\n", ev)
				break

			default:

				fmt.Printf("Unexpected (%+v): %v\n", ev, msg.Data)
			}
		}
	}
}
