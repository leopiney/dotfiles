install:
	#
	# Install Brew
	#
	brew --version || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	for dep in vim fzf python gitsh watchman ; do \
		brew info $$dep || brew install $$dep || brew upgrade $$dep ; \
	done

	brew install python@2

	#
	# Check Brew installation
	#
	brew doctor

	#
	# Install Haskell stuff
	#
	brew install haskell-platform

	stack install hlint ghc-mod hpack

install-android:
	#
	# Install Termux programs
	#
	pkg install	\
		git	\
		make	\
		openssh	\
		curl	\
		rsync	\
		python	\
		perl

deploy:
	#
	# Install/Update Vim Plug
	#
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	# 
	# Copy dot files
	#
	cp ./.vimrc ~/.vimrc
	cp ./.bashrc ~/.bashrc
	cp ./.bash_profile ~/.bash_profile
	cp ./git-utils.py ~/git-utils.py
	rsync -r ./.config/ ~/.config/

	#
	# Install base python2 virtualenv to access the activate_this.py file
	#
	pip list --format=columns | grep -F virtualenv || pip install virtualenv
	[ -d "$$HOME/.env-base" ] || virtualenv ~/.env-base

	#
	# Install Vim plugins
	#
	vim +PlugInstall +qall
	make -C /Users/leo/.vim/plugged/vimproc.vim

	#
	# Install other pip utils
	#
	pip install fire sh

	#
	# Add git global configurations
	#
	git config --global alias.commit-to '!python ~/git-utils.py commit-to'
	git config --global alias.branch-remove-dangling '!git branch --merged | egrep -v "(^\*|master|dev|pro-reports)" | xargs git branch -d'
	git config --global user.email "leopiney@gmail.com"
	git config --global user.name "Leonardo Piñeyro"
