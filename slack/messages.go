package slack

import qml "gopkg.in/qml.v1"
import slackApi "github.com/nlopes/slack"

type Messages struct {
	channelIDLatestMessageID map[string]int
	list                     []Message
	Len                      int
}

type Message struct {
	Type      string
	Channel   string
	User      string
	Text      string
	Timestamp string
	IsStarred bool
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
	mIndex := ms.Len - 1
	m := ms.list[mIndex]
	if m.Channel == channelID && ms.channelIDLatestMessageID[m.Channel] < mIndex {
		ms.channelIDLatestMessageID[m.Channel] = mIndex
		return m
	}
	return Message{}
}

func (ms *Messages) Add(msg *slackApi.MessageEvent) {
	m := Message{}
	m.transformFromBackend(msg)

	ms.list = append(ms.list, m)
	ms.Len = len(ms.list)

	qml.Changed(ms, &ms.Len)
}
