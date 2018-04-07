
install:
	# Install Brew
	brew --version || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install vim fzf python gitsh watchman

	# Vim plug
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	
	# Check Brew installation
	brew doctor

deploy:
	cp ./.vimrc ~/.vimrc
	cp ./.bashrc ~/.bashrc
	cp ./.bash_profile ~/.bash_profile
	cp -r ./.config ~/.config

	pip install virtualenv
	virtualenv ~/.env-base
