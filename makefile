install-deps:
	#
	# Install brew dependencies
	#
	brew tap thoughtbot/formulae

	for dep in desk vim ag fzf python pyenv gitsh watchman tmux ; do \
		brew install $$dep || brew upgrade $$dep ; \
	done

install-apps:
	#
	# Install macOS apps
	#
	brew tap homebrew/cask-fonts
	brew cask install font-fira-code hyper visual-studio-code spectacle slack telegram

install:
	#
	# Install Brew
	#
	brew --version || echo "Please install Homebrew: https://brew.sh/" && exit

	$(MAKE) install-deps

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
	cp ./.ghci ~

	mkdir -p ~/.stack
	rsync -r ./.stack/ ~/.stack/


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


vim:
	#
	# Install/Update Vim Plug
	#
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	#
	# Install Vim plugins
	#
	cp ./.vimrc ~
	vim +PlugInstall +qall


vscode:
	#
	# Install VScode extensions
	#
	mkdir -p ~/Library/Application Support/Code/User/

	cp ./vscode-settings.json "~/Library/Application Support/Code/User/settings.json"
	cp ./vscode-keybindings.json "~/Library/Application Support/Code/User/keybindings.json"
	cat ./vscode-extensions.txt | xargs -L 1 code --install-extension


deploy:
	#
	# Set default hostnames
	#
	$(shell bash -c 'scutil --set ComputerName "lp-macbook"')
	$(shell bash -c 'scutil --set HostName "lp-macbook"')

	#
	# Copy dot files
	#
	cp ./.bashrc ~
	cp ./.bash_profile ~
	cp ./git-commit-to.pl ~/.git-commit-to.pl
	cp ./.fzf.bash ~
	cp ./.tmux.conf ~
	cp ./.hyper.js ~

	mkdir -p ~/.config
	rsync -r ./.config/ ~/.config/

	#
	# Add git global configurations
	#
	git config --global alias.commit-to '!perl ~/.git-commit-to.pl'
	git config --global alias.branch-remove-dangling '!git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
	git config --global alias.alias.grog 'log --graph --abbrev-commit --decorate --all --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)"'
	git config --global user.email "leopiney@gmail.com"
	git config --global user.name "Leonardo Piñeyro"
	git config --global push.default current
