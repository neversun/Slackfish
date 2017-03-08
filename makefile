SSH_SAILFISH = ssh -p 2222 -i $(HOME)/SailfishOS/vmshare/ssh/private_keys/engine/mersdk mersdk@localhost $(1)

build: sync sailfish_build deploy

deploy: sailfish_deploy

sync:
	rsync --exclude-from=.rsyncignore -Eahrve 'ssh -p 2222 -i $(HOME)/SailfishOS/vmshare/ssh/private_keys/engine/mersdk' $(HOME)/go/src/github.com/neversun/Slackfish mersdk@localhost:/home/mersdk/src/github.com/neversun

clean:
	$(call SSH_SAILFISH,'rm -rf /home/mersdk/src/github.com/neversun/Slackfish/')

sailfish_build:
	$(call SSH_SAILFISH,'cd /home/mersdk/src/github.com/neversun/Slackfish/; mb2 build')

sailfish_deploy:
	$(call SSH_SAILFISH,'cd /home/mersdk/src/github.com/neversun/Slackfish/; mb2 -s rpm/harbour-slackfish.spec -d "SailfishOS Emulator" deploy  --sdk')
