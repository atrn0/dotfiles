MAC_HOME=macOS/HOME


mac:
	ls -A $(MAC_HOME) | xargs -I {} ln -sf $(PWD)/$(MAC_HOME)/{} ~/
