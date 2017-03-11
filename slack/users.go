package slack

import (
	"encoding/json"
	"errors"
	slackApi "github.com/nlopes/slack"
	qml "gopkg.in/qml.v1"
	"reflect"
)

// Users holding collection of all users
type Users struct {
	users        []User
	Len          int
	LatestChange int // If sth changed in users, but not the lenght, we need a way to inform qml bindings
}

// User is a Slack user accounts
type User struct {
	Profile           UserProfile `json:"profile"`
	ID                string      `json:"id"`
	Name              string      `json:"name"`
	Deleted           bool        `json:"deleted"`
	Color             string      `json:"color"`
	RealName          string      `json:"realName"`
	TZ                string      `json:"tz"`
	TZLabel           string      `json:"tzLabel"`
	TZOffset          int         `json:"tzOffset"`
	IsBot             bool        `json:"isBot"`
	IsAdmin           bool        `json:"isAdmin"`
	IsOwner           bool        `json:"isOwner"`
	IsPrimaryOwner    bool        `json:"isPrimaryOwner"`
	IsRestricted      bool        `json:"isRestricted"`
	IsUltraRestricted bool        `json:"isUltraRestricted"`
	Has2FA            bool        `json:"has2FA"`
	HasFiles          bool        `json:"hasFiles"`
	Active            bool        `json:"active"`
}

// UserProfile holds the personal information of a @User
type UserProfile struct {
	FirstName          string `json:"firstName"`
	LastName           string `json:"lastName"`
	RealName           string `json:"realName"`
	RealNameNormalized string `json:"realNameNormalized"`
	Email              string `json:"email"`
	Skype              string `json:"skype"`
	Phone              string `json:"phone"`
	Image24            string `json:"image24"`
	Image32            string `json:"image32"`
	Image48            string `json:"image48"`
	Image72            string `json:"image72"`
	Image192           string `json:"image192"`
	ImageOriginal      string `json:"imageOriginal"`
	Title              string `json:"title"`
	BotID              string `json:"botId,omitempty"`
	APIAppID           string `json:"apiAppId,omitempty"`
}

func (up *UserProfile) transformFromBack(userProfile *slackApi.UserProfile) {
	up.FirstName = userProfile.FirstName
	up.LastName = userProfile.LastName
	up.RealName = userProfile.RealName
	up.RealNameNormalized = userProfile.RealNameNormalized
	up.Email = userProfile.Email
	up.Skype = userProfile.Skype
	up.Phone = userProfile.Phone
	up.Image24 = userProfile.Image24
	up.Image32 = userProfile.Image32
	up.Image48 = userProfile.Image48
	up.Image72 = userProfile.Image72
	up.Image192 = userProfile.Image192
	up.ImageOriginal = userProfile.ImageOriginal
	up.Title = userProfile.Title
	// up.BotID = userProfile.BotID // FIXME: not defined on *slackApi.UserProfile
	// up.APIAppID = userProfile.ApiAppID // FIXME: not defined on *slackApi.UserProfile
}

func (u *User) transformFromBackend(user *slackApi.User) {
	up := UserProfile{}
	up.transformFromBack(&user.Profile)
	u.Profile = up

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
	u.Active = presenceToActive(user.Presence)
}

func (us *Users) getUsers(ID string) (users map[string]User) {
	users = map[string]User{}
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

	return users
}

// Get returns a all (or a single user) as JSON string
func (us *Users) Get(ID string) string {
	users := us.getUsers(ID)
	s, _ := json.Marshal(users)
	infoLn(string(s))
	return string(s)
}

func (us *Users) getInternal(ID string) map[string]User {
	return us.getUsers(ID)
}

// AddUsers converts users from backend
func (us *Users) AddUsers(users []slackApi.User) {
	for _, user := range users {
		u := User{}
		u.transformFromBackend(&user)
		us.users = append(us.users, u)
	}

	us.Len = len(us.users)
	qml.Changed(us, &us.Len)
}

func (us *Users) find(id string) (i int, err error) {
	if id == "" {
		return i, errors.New("id cannot be empty")
	}

	for index, user := range us.users {
		if user.ID == id {
			return index, nil
		}
	}
	return i, errors.New("id not found")
}

func presenceToActive(presence string) bool {
	return presence == "active"
}

func (us *Users) set(id string, values map[string]interface{}) error {
	i, ok := us.find(id)
	if ok != nil {
		return ok
	}

	userModelValue := reflect.ValueOf(&us.users[i])
	for key, value := range values {
		if key == "presence" {
			key = "Active"
			value = presenceToActive(value.(string))
		}
		infoLn(userModelValue, key, value)
		Set(userModelValue, key, value)
		us.users[i] = *userModelValue.Interface().(*User)
	}
	us.incrementLatest()
	return nil
}

func (us *Users) incrementLatest() {
	us.LatestChange++
	qml.Changed(us, &us.LatestChange)
}
