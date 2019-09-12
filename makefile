install-deps:
	#
	# Install brew dependencies
	#
	for dep in desk vim fzf python gitsh watchman ; do \
		brew info $$dep || brew install $$dep || brew upgrade $$dep ; \
	done

	gem install teamocil
	mkdir -p ~/.teamocil

install:
	#
	# Install Brew
	#
	brew --version || /usr/bin/ruby -e \
		"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	$(MAKE) install-deps

	brew install python@2

	#
	# Check Brew installation
	#
	brew doctor

install-haskell:
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
	cp ./.vimrc ~
	cp ./.bashrc ~
	cp ./.ghci ~
	cp ./.bash_profile ~
	cp ./git-commit-to.pl ~
	cp ./.tmux.conf ~

	mkdir -p ~/.config
	rsync -r ./.config/ ~/.config/

	mkdir -p ~/.teamocil
	rsync -r ./.teamocil/ ~/.teamocil/

	mkdir -p ~/.stack
	rsync -r ./.stack/ ~/.stack/

	#
	# Install base python2 virtualenv to access the activate_this.py file
	#
	pip list --format=columns | grep -F virtualenv || pip install virtualenv
	[ -d "$$HOME/.env-base" ] || virtualenv ~/.env-base

	#
	# Install Vim plugins
	#
	vim +PlugInstall +qall
	make -C ~/.vim/plugged/vimproc.vim

	#
	# Install other pip utils
	#
	pip install fire sh

	#
	# Add git global configurations
	#
	git config --global alias.commit-to '!perl ~/git-commit-to.pl'
	git config --global alias.branch-remove-dangling '!git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
	git config --global alias.alias.grog 'log --graph --abbrev-commit --decorate --all --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
	git config --global user.email "leopiney@gmail.com"
	git config --global user.name "Leonardo Piñeyro"
	git config --global push.default current

vscode:
	#
	# Install VScode extensions
	#
	cp ./vscode-settings.json "~/Library/Application Support/Code/User/settings.json"
	cp ./vscode-keybindings.json "~/Library/Application Support/Code/User/keybindings.json"
	cat ./vscode-extensions.txt | xargs -L 1 code --install-extension

