dud:
	@echo "make install to install"
	@echo "make update to update"

compile:
	g++ tailTalk.cpp -o tailTalk -std=c++11 -pthread

install: 
	chmod 770 myt
	chmod 770 tailTalk
	./DOalias
	mv ../myTalk ~/.myTalk		# Will error if ~/.myTalk already exists (creates ~/.myTalk/myTalk). Too lazzy to fix.
	@echo "This will have moved your pwd. I suggest \"cd ~\" to get back to your home"

updateTar: 
	if [ -f ~/.myTalk/myt ]; then ~/.myTalk/myt --kill; fi
	cp ~/../jourmeob/drop/myTalk.tar ~/
	tar xvf ~/myTalk.tar -C ~/
	rm ~/myTalk.tar
	cp ~/myTalk/* ~/.myTalk/
	rm -rf ~/myTalk
	./DOalias
	@echo "This may have updated your myTalk. Your file handle may have expired. I suggest \"cd ~\" to get back to your home"

update:
	if [ -f ~/.myTalk/myt ]; then ~/.myTalk/myt --kill; fi
	if [ ! -d ~/.myTalk ]; then mkdir ~/.myTalk; fi
	
	if [ -d ~/.myTalk/gitRepo ]; then rm -rf ~/.myTalk/gitRepo; fi
	
	git clone https://github.com/ojourmel/myTalk.git ~/.myTalk/gitRepo
	
	cp ~/.myTalk/gitRepo/* ~/.myTalk/ 2> /dev/null
	rm -rf ~/.myTalk/gitRepo
	./DOalias
	
	@echo "This may have updated your myTalk. Your file handle may have expired. I suggest \"cd ~\" to get back to your home"


GITDIR := $(shell git symbolic-ref HEAD 2>/dev/null)

deployLocal:
	if [ ! -d ~/.myTalk ]; then mkdir ~/.myTalk; fi
	
	if [ ! -n "$(GITDIR)" ]; then \
		echo "Not a Git Reop!"; \
	else \
		cp -v ./* ~/.myTalk/; \
	fi
	@echo "myt has been updated to current branch of PWD"

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
