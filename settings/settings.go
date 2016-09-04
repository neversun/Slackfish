package settings

import (
	"encoding/json"
	"io/ioutil"
)

// Settings serializes to a JSON file at choosen Location
type Settings struct {
	Token    string
	Location string
}

// Save saves Settings to Location
func (s *Settings) Save() error {
	data, err := json.Marshal(s)
	if err != nil {
		return err
	}

	return ioutil.WriteFile(s.Location, data, 0600)
}

// Load loads from Location
func (s *Settings) Load() error {
	data, err := ioutil.ReadFile(s.Location)
	if err != nil {
		return err
	}

	err = json.Unmarshal(data, s)
	if err != nil {
		return err
	}

	return nil
}
