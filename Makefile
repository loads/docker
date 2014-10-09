HERE = $(shell pwd)
BIN = $(HERE)/bin
PYTHON = $(BIN)/python

INSTALL = $(BIN)/pip install --no-deps

BUILD_DIRS = bin build include lib lib64 man share


.PHONY: all build_influx build_broker build run

all: build

$(PYTHON):
	virtualenv .

build_influx:
	docker build -t loads/influx influx

build_broker:
	docker build -t loads/loads-broker broker

build: $(PYTHON)
	$(BIN)/pip install git+https://github.com/loads/loads-broker.git
	$(BIN)/pip install circus
	docker pull registry

run:
	$(BIN)/circusd --daemon circus.ini
