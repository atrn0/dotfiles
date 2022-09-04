UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
ROOT := Darwin
endif

ifndef ROOT
$(error unknown uname: $(UNAME))
endif

.PHONY: all echo link Darwin dump

all: echo $(UNAME)

echo:
	@echo uname: $(UNAME)
	@echo root: $(PWD)/$(ROOT)
	@echo

Darwin: link
	$(MAKE) link ROOT=custom
	cd $(HOME)/.config/dotfiles; \
	BREWFILE=Brewfile bash ./restore.sh; \
	cd -

link:
	cd $(ROOT); \
	find . -type d -exec mkdir -v -p /{} \;	-o \( -type f -o -type l \) -not -name '.gitignore' -exec ln -vsf $$PWD/{} /{} \;; \
	cd - > /dev/null
	@echo

dump:
	cd $(HOME)/.config/dotfiles; \
	brew bundle dump -f --file=Brewfile; \
	cd -
