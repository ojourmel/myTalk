dud:
	@echo "make install to install"
	@echo "make update to update"

install:
	chmod 770 myt
	chmod 770 tailTalk
	./DOalias
	mv ../myTalk ~/.myTalk		# Will error if ~/.myTalk already exists (creates ~/.myTalk/myTalk). Too lazzy to fix.
	@echo "This will have moved your pwd. I sugest \"cd ~\" to get back to your home"

update: 
	if [ -f ~/.myTalk/myt ]; then ~/.myTalk/myt --kill; fi
	cp ~/../jourmeob/drop/myTalk.tar ~/
	tar xvf ~/myTalk.tar -C ~/
	rm ~/myTalk.tar
	cp ~/myTalk/* ~/.myTalk/
	rm -rf ~/myTalk
	./DOalias
	@echo "This may have updated your myTalk. Your file handle may have expired. I sugest \"cd ~\" to get back to your home"



install-nc: ~/.myTalk
	cp * ~/.myTalk
	chmod 700 ~/.myTalk/myt
	chmod 700 ~/.myTalk/tailTalk
	~/.myTalk/DOalias
	@echo "Installed"

TEMPDIR := $(shell mktemp -d)

update-nc: ~/.myTalk
	if [ -f ~/.myTalk/myt ]; then  ~/.myTalk/myt --kill; fi
	cp ~/../jourmeob/drop/myTalk.tar $(TEMPDIR)
	tar xvf $(TEMPDIR)/myTalk.tar -C $(TEMPDIR)
	cp $(TEMPDIR)/myTalk/* ~/.myTalk/ 
	rm -rf $(TEMPDIR)

	~/.myTalk/DOalias
	@echo "myTalk Updated"

~/.myTalk:
	mkdir ~/.myTalk
