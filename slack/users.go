package slack

import (
	"encoding/json"

	slackApi "github.com/nlopes/slack"
)

type Users struct {
	users []User
	Len   int
}

type User struct {
	// Profile           UserProfile
	ID                string `json:"id"`
	Name              string `json:"name"`
	Deleted           bool   `json:"deleted"`
	Color             string `json:"color"`
	RealName          string `json:"realName"`
	TZ                string `json:"tz"`
	TZLabel           string `json:"tzLabel"`
	TZOffset          int    `json:"tzOffset"`
	IsBot             bool   `json:"isBot"`
	IsAdmin           bool   `json:"isAdmin"`
	IsOwner           bool   `json:"isOwner"`
	IsPrimaryOwner    bool   `json:"isPrimaryOwner"`
	IsRestricted      bool   `json:"isRestricted"`
	IsUltraRestricted bool   `json:"isUltraRestricted"`
	Has2FA            bool   `json:"has2FA"`
	HasFiles          bool   `json:"hasFiles"`
	Presence          string `json:"presence"`
}

func (u *User) transformFromBackend(user *slackApi.User) {
	u.ID = user.ID
	u.Name = user.Name
	u.Deleted = user.Deleted
	u.Color = user.Color
	u.RealName = user.RealName
	u.TZ = user.TZ
	u.TZLabel = user.TZLabel
	u.TZOffset = user.TZOffset
	u.IsBot = user.IsBot
	u.IsAdmin = user.IsAdmin
	u.IsOwner = user.IsOwner
	u.IsPrimaryOwner = user.IsPrimaryOwner
	u.IsRestricted = user.IsRestricted
	u.IsUltraRestricted = user.IsUltraRestricted
	u.Has2FA = user.Has2FA
	u.HasFiles = user.HasFiles
	u.Presence = user.Presence
}

func (us *Users) Get(ID string) string {
	users := map[string]User{}
	if ID != "" {
		for _, user := range us.users {
			if user.ID != ID {
				continue
			}

			users[user.ID] = user
		}
	} else {
		for _, user := range us.users {
			users[user.ID] = user
		}
	}

	s, _ := json.Marshal(users)
	return string(s)
}

func (us *Users) AddUsers(users []slackApi.User) {
	for _, user := range users {
		u := User{}
		u.transformFromBackend(&user)
		us.users = append(us.users, u)
	}
}
