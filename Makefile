bootstrap:
ifeq ($(strip $(shell command -v brew 2> /dev/null)),)
	$(error "`brew` is not available, please install homebrew")
endif
ifeq ($(strip $(shell command -v xcodegen 2> /dev/null)),)
	brew install xcodegen
endif
ifeq ($(strip $(shell command -v swiftformat 2> /dev/null)),)
	brew install swiftformat
endif

generate-carthage-project:
	xcodegen generate

format:
	swiftformat . 2> /dev/null
