MAC_HOME=macOS/HOME
BREWFILE=macOS/Brewfile


mac:
	BREWFILE=$(BREWFILE) MAC_HOME=$(MAC_HOME) sh macOS/restore.sh

backup-mac:
	# dump homebrew packages
	brew bundle dump -f --file=$(BREWFILE)
