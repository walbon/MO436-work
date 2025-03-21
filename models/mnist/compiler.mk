.PHONY : clean build all

MODEL ?= mnist
MODELINPUT ?= "data_0",float,[1,1,28,28]
BUNDLE ?= bin
MEMOPT ?= false
MO436-features ?= true

all: clean build

build: ${BUNDLE}/$(MODEL).o

${BUNDLE}/$(MODEL).o : $(MODEL).onnx
	@echo 'Build the bundle object $@:'
	${GLOWBIN}/model-compiler \
		-model=$(MODEL).onnx \
		-model-input=$(MODELINPUT) \
		-emit-bundle=$(BUNDLE) \
		-dump-graph-DAG-before-compile=$(MODEL)-before.dot \
		-dump-graph-DAG=$(MODEL)-after.dot \
		-reuse-activation-memory-allocations=$(MEMOPT) \
		-backend=CPU \
		-MO436Features=$(MO436-features) \
		-dump-ir > $(MODEL).lir

clean:
	rm -f ${BUNDLE}/$(MODEL).o
