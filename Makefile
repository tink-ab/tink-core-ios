bootstrap:
	ifeq ($(strip $(shell command -v brew 2> /dev/null)),)
		$(error "`brew` is not available, please install homebrew")
	endif
