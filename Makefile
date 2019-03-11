.PHONY: all
all: build

.PHONY: build
build:
		@echo "test"

.PHONY clean
clean:
		rm -rf .kitchen .terraform