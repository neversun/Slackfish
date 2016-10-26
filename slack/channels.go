package slack

import qml "gopkg.in/qml.v1"
import slackApi "github.com/nlopes/slack"

var ChannelsByID map[string]*Channel

type Channels struct {
	list []Channel
	Len  int
}

type Channel struct {
	ID         string
	Name       string
	Created    string
	Creator    string
	IsArchived bool
	IsGeneral  bool
	IsMember   bool
	IsStarred  bool
	// Members            array
	Topic    Topic
	Purpose  Purpose
	LastRead string
	// Latest             object
	UnreadCount        int
	UnreadCountDisplay int
}

type Topic struct {
	Value   string
	Creator string
	LastSet string
}

type Purpose struct {
	Value   string
	Creator string
	LastSet string
}

func (p *Purpose) transformFromBackend(purpose slackApi.Purpose) {
	p.Value = purpose.Value
	p.Creator = purpose.Creator
	p.LastSet = purpose.LastSet.String()
}

func (t *Topic) transformFromBackend(topic slackApi.Topic) {
	t.Value = topic.Value
	t.Creator = topic.Creator
	t.LastSet = topic.LastSet.String()
}

func (c *Channel) transformFromBackend(channel slackApi.Channel) {
	t := Topic{}
	t.transformFromBackend(channel.Topic)
	p := Purpose{}
	p.transformFromBackend(channel.Purpose)

	c.ID = channel.ID
	c.Name = channel.Name
	c.Created = channel.Created.String()
	c.Creator = channel.Creator
	c.IsArchived = channel.IsArchived
	c.IsGeneral = channel.IsGeneral
	c.IsMember = channel.IsMember
	// Members            array,
	c.Topic = t
	c.Purpose = p
	c.LastRead = channel.LastRead
	// Latest             object,
	c.UnreadCount = channel.UnreadCount
	c.UnreadCountDisplay = channel.UnreadCountDisplay
}

func (cs *Channels) Get(i int) Channel {
	infoLn(cs.list[i])
	return cs.list[i]
}

func (cs *Channels) GetChannels(excludeArchived bool) {
	channels, err := API.GetChannels(excludeArchived)
	if err != nil {
		errorLn(err.Error())
		return
	}

	for _, channel := range channels {
		infoLn(channel)
		c := Channel{}
		c.transformFromBackend(channel)

		cs.list = append(cs.list, c)
	}
	cs.Len = len(cs.list)

	qml.Changed(cs, &cs.Len)
}
