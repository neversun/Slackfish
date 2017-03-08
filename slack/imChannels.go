package slack

import (
	slackApi "github.com/nlopes/slack"
	qml "gopkg.in/qml.v1"
)

var channelID string

// IMs is a list of IM
type IMs struct {
	list []IM
	Len  int
}

// IM describes an instantMessageChannel
type IM struct {
	IsIM          bool   `json:"isIm"`
	User          string `json:"user"`
	IsUserDeleted bool   `json:"isUserDeleted"`
}

// AddIMs parses IM channels from backend and saves them
func (ims *IMs) AddIMs(instantMessageChannels []slackApi.IM) {
	infoLn("instantMessageChannels", instantMessageChannels)
	for _, instantMessageChannel := range instantMessageChannels {
		im := IM{}
		im.transformFromBackend(&instantMessageChannel)
		ims.list = append(ims.list, im)
	}

	ims.Len = len(ims.list)
	qml.Changed(ims, &ims.Len)
}

func (im *IM) transformFromBackend(instantMessageChannel *slackApi.IM) {
	im.IsIM = instantMessageChannel.IsIM
	im.User = instantMessageChannel.User
	im.IsUserDeleted = instantMessageChannel.IsUserDeleted
}

// Open opens an channel based on a userID and sets the current channel
func (ims *IMs) Open(userID string) {
	_, _, chID, err := API.OpenIMChannel(userID)
	if err != nil {
		errorLn(err.Error())
	}

	channelID = chID
}

// GetIMs returns all IM-channels
func (ims *IMs) GetIMs() {
	imChannels, err := API.GetIMChannels()
	if err != nil {
		errorLn(err.Error())
		return
	}

	for _, channel := range imChannels {
		infoLn(channel)
		c := IM{}
		c.transformFromBackend(&channel)

		ims.list = append(ims.list, c)
	}
	ims.Len = len(ims.list)

	qml.Changed(ims, &ims.Len)
}

// Close closes the currently open channel
func (ims *IMs) Close() {
	_, _, err := API.CloseIMChannel(channelID)
	if err != nil {
		errorLn(err.Error())
	}

	channelID = ""
}

// Get returns an IM
func (ims *IMs) Get(i int) IM {
	infoLn(ims.list[i])
	return ims.list[i]
}

// GetChannel returns a channel informations of an IM
func (ims *IMs) GetChannel(i int) Channel {
	infoLn(ims.list[i])
	userID := ims.list[i].User
	_, _, channelID, err := API.OpenIMChannel(userID)
	if err != nil {
		errorLn(err)
	}
	infoLn(channelID)
	return Slack.Channels.GetByID(channelID, userID)
}
