package slack

import (
	"fmt"

	slackApi "github.com/nlopes/slack"
)

var API *slackApi.Client
var slackRtm *slackApi.RTM

var messageID = 0
var token string

type Slack struct {
	messages *Messages
	users    *Users
}

func (s *Slack) Init(msgs *Messages, users *Users) {
	s.messages = msgs
	s.users = users
}

// Connect establishes a connection to slack API
func (s *Slack) Connect(tkn string) {
	token = tkn
	API = slackApi.New(tkn)

	slackApi.SetLogger(logger)
	API.SetDebug(false)

	slackRtm = API.NewRTM()
	info, _, _ := slackRtm.StartRTM()
	s.users.AddUsers(info.Users)

	go slackRtm.ManageConnection()

	go processEvents(s)
}

func (s *Slack) Disconnect() {
	err := slackRtm.Disconnect()
	if err != nil {
		errorLn(err.Error())
	}
}

func processEvents(s *Slack) {
	for {
		select {
		case msg := <-slackRtm.IncomingEvents:
			fmt.Print("Event Received: ")
			switch ev := msg.Data.(type) {
			case *slackApi.HelloEvent:
				// Ignore hello

			case *slackApi.ConnectedEvent:
				fmt.Println("Infos:", ev.Info)
				fmt.Println("Connection counter:", ev.ConnectionCount)

			case *slackApi.MessageEvent:
				fmt.Printf("Message: %v\n", ev)
				s.messages.Add(&ev.Msg)

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
				s.messages.MarkSent(ev.ReplyTo)

			default:

				fmt.Printf("Unexpected (%+v): %v\n", ev, msg.Data)
			}
		}
	}
}
