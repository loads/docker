HERE = $(shell pwd)
BIN = $(HERE)/bin
PYTHON = $(BIN)/python

INSTALL = $(BIN)/pip install --no-deps

BUILD_DIRS = bin build include lib lib64 man share


.PHONY: all test docs build_extras

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

run:
	$(BIN)/circusd -d circus.ini
