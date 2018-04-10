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
	cp -r ./.config ~/.config

	#
	# Install base python2 virtualenv to access the activate_this.py file
	#
	pip list --format=columns | grep -F virtualenv || pip install virtualenv
	[ -d "$$HOME/.env-base" ] || virtualenv ~/.env-base
