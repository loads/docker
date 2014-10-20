HERE = $(shell pwd)
BIN = $(HERE)/bin
PYTHON = $(BIN)/python
INSTALL = $(BIN)/pip install --no-deps
BUILD_DIRS = bin build include lib lib64 man share


.PHONY: all build_influx build_broker build run

all: build

$(PYTHON):
	virtualenv .

build_broker:
	docker build -t loads/loads-broker broker

build: $(PYTHON)
	$(BIN)/pip install git+https://github.com/loads/loads-broker.git
	docker pull registry
	docker pull tutum/grafana
	docker pull tutum/influxdb


#@docker run -d -p 5000:5000 -v $(HERE):/registry-conf -e DOCKER_REGISTRY_CONFIG=/registry-conf/reg-conf.yml -e SETTINGS_FLAVOR=local --cidfile=.registry registry

start:
	@echo Starting...
	@docker run -d -p 8086:8086 -p 8084:8084 -e PRE_CREATE_DB="test" -e SSL_SUPPORT=yes tutum/influxdb
	@docker run -d -p 8080:8080 --expose 8080 -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) --cidfile=.broker loads/loads-broker
	@echo Started.

stop:
	@echo Stopping...
	-@if [ -f ".influx" ]; then docker stop `cat .influx` ; docker rm `cat .influx`; rm -f .influx; fi
	-@if [ -f ".broker" ]; then docker stop `cat .broker` ; docker rm `cat .broker`; rm -f .broker; fi
	-@if [ -f ".registry" ]; then docker stop `cat .registry` ; docker rm `cat .registry`; rm -f .registry; fi
	@echo Stopped

