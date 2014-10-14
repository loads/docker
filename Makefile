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
	docker pull registry
	docker pull grafana

start:
	@echo Starting...
	@docker run -d -p 8080:8080 --expose 8080 -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) --cidfile=.broker loads/loads-broker
	#@docker run -d -p 5000:5000 -v $(HERE):/registry-conf -e DOCKER_REGISTRY_CONFIG=/registry-conf/reg-conf.yml -e SETTINGS_FLAVOR=local --cidfile=.registry registry
	@docker run -d -p 8083:8083 -p 8086:8086 --expose 8090 --expose 8099 --cidfile=.influx loads/influx
	@docker run -d -p 8088:80 -e HTTP_USER=admin -e HTTP_PASS=admin -e INFLUXDB_HOST=localhost --cidfile=.grafana tutum/grafana
	@echo Started.

stop:
	@echo Stopping...
	-@if [ -f ".influx" ]; then docker stop `cat .influx` ; docker rm `cat .influx`; rm -f .influx; fi
	-@if [ -f ".broker" ]; then docker stop `cat .broker` ; docker rm `cat .broker`; rm -f .broker; fi
	-@if [ -f ".registry" ]; then docker stop `cat .registry` ; docker rm `cat .registry`; rm -f .registry; fi
	-@if [ -f ".grafana" ]; then docker stop `cat .grafana` ; docker rm `cat .grafana`; rm -f .grafana; fi
	@echo Stopped

