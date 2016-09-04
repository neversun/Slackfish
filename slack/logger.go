package slack

import (
	"log"
	"os"
)

var logger *log.Logger

func init() {
	logger = log.New(os.Stdout, "slack-bot: ", log.Lshortfile|log.LstdFlags)
}

func errorLn(v ...interface{}) {
	log.Printf("ERROR: %+v\n", v)
}

func warnLn(v ...interface{}) {
	log.Printf("WARN: %+v\n", v)
}

func infoLn(v ...interface{}) {
	log.Printf("INFO: %+v\n", v)
}
