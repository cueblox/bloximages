SOURCE_FILES?=./...
TEST_PATTERN?=.
TEST_OPTIONS?=
TEST_TIMEOUT?=15m
TEST_PARALLEL?=2
DOCKER_BUILDKIT?=1
export DOCKER_BUILDKIT

export PATH := ./bin:$(PATH)
export GO111MODULE := on

bin/golangci-lint:
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.42.1

# Install all the build and lint dependencies
setup: bin/golangci-lint
	go mod tidy
	git config core.hooksPath .githooks
	GO111MODULE=on go get mvdan.cc/gofumpt

.PHONY: setup

test:
	go test $(TEST_OPTIONS) -p $(TEST_PARALLEL) -v -failfast -race -coverpkg=./... -covermode=atomic -coverprofile=coverage.txt $(SOURCE_FILES) -run $(TEST_PATTERN) -timeout=$(TEST_TIMEOUT)
.PHONY: test

cover: test
	go tool cover -html=coverage.txt
.PHONY: cover

fmt:
	gofumpt -w .
.PHONY: fmt

lint: check
	./bin/golangci-lint run
.PHONY: check

ci: lint test
.PHONY: ci

build:
	go build -o bloximages main.go
.PHONY: build

install:
	go install
.PHONY: install

deps:
	go get -u
	go mod tidy
	go mod verify
.PHONY: deps


todo:
	@grep \
		--exclude-dir=vendor \
		--exclude-dir=node_modules \
		--exclude-dir=bin \
		--exclude=Makefile \
		--text \
		--color \
		-nRo -E ' TODO:.*|SkipNow' .
.PHONY: todo

.DEFAULT_GOAL := build
