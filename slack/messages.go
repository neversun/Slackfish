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

func (m *Message) transformFromBackend(msg *slackApi.Msg) {
	m.Type = msg.Type
	m.Channel = msg.Channel
	m.User = msg.User
	m.Text = msg.Text
	m.Timestamp = msg.Timestamp
	m.IsStarred = msg.IsStarred
}

// GetLatest returns the latest message for given channel
func (ms *Messages) GetLatest(channelID string) Message {
	m := ms.list[len(ms.list)-1]
	if m.Channel == channelID {
		return m
	}
	return Message{}
}

func (ms *Messages) GetAll(channelID string) string {
	var chMsg []Message
	for _, m := range ms.list {
		if m.Channel == channelID {
			chMsg = append(chMsg, m)
		}
	}
	s, _ := json.Marshal(chMsg)
	return string(s)
}

func (ms *Messages) GetAllWithHistory(channelID string, timestamp string) string {
	params := slackApi.HistoryParameters{
		Count:  30,
		Inclusive: true,
	}
	if (timestamp != "") {
		params.Latest = timestamp
	}

	h, err := API.GetChannelHistory(channelID, params)
	if err != nil {
		errorLn(err.Error())
		return ""
	}
	infoLn("66", h)

	var tmpMs []Message
	for i := len(h.Messages)-1; i > 0; i-- {
		msg := Message{}
		msg.transformFromBackend(&h.Messages[i].Msg)
		msg.Channel = channelID
		tmpMs = append(tmpMs, msg)
	}
	ms.list = append(tmpMs, ms.list...)
	ms.Len = len(ms.list)
	infoLn(ms.list)
	s, _ := json.Marshal(ms.list)
	return string(s)
}

func (ms *Messages) Add(msg *slackApi.Msg) {
	m := Message{}
	m.transformFromBackend(msg)

	infoLn("Add", m)
	ms.list = append(ms.list, m)
	ms.Len = len(ms.list)

	qml.Changed(ms, &ms.Len)
}
