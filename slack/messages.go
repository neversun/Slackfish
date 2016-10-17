package slack

import qml "gopkg.in/qml.v1"
import slackApi "github.com/nlopes/slack"
import "encoding/json"

type Messages struct {
	list []Message
	Len  int
}

type Message struct {
	Type      string `json:"type"`
	Channel   string `json:"channel"`
	User      string `json:"user"`
	Text      string `json:"text"`
	Timestamp string `json:"timestamp"`
	IsStarred bool   `json:"isStarred"`
	// PinnedTo []string
	// Attachments []Attachment
	// Edited *Edited
}

func (m *Message) transformFromBackend(msg *slackApi.MessageEvent) {
	m.Type = msg.Type
	m.Channel = msg.Channel
	m.User = msg.User
	m.Text = msg.Text
	m.Timestamp = msg.Timestamp
	m.IsStarred = msg.IsStarred
}

// GetLatest returns the latest message for given channel
func (ms *Messages) GetLatest(channelID string) Message {
	if m.Channel == channelID {
		return m
	}
	return Message{}
}

func (ms *Messages) GetAll(channelID string) string {
	var mf []Message
	for _, m := range ms.list {
		if m.Channel == channelID {
			mf = append(mf, m)
		}
	}
	s, _ := json.Marshal(mf)
	return string(s)
}

func (ms *Messages) Add(msg *slackApi.MessageEvent) {
	m := Message{}
	m.transformFromBackend(msg)

	ms.list = append(ms.list, m)
	ms.Len = len(ms.list)

	qml.Changed(ms, &ms.Len)
}
