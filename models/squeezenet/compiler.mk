.PHONY : clean build all

MODEL ?= squeezenet
MODELINPUT ?= "Placeholder",float,[1,3,224,224]
BAPI ?= static
BUNDLE ?= bin
MEMOPT ?= false
MO436Features ?= true

all: clean build

build: ${BUNDLE}/$(MODEL).o

${BUNDLE}/$(MODEL).o : $(MODEL).onnx
	@echo 'Build the bundle object $@:'
	${GLOWBIN}/model-compiler \
		-model=$(MODEL).onnx \
		-model-input=$(MODELINPUT) \
		-bundle-api=$(BAPI) \
		-emit-bundle=$(BUNDLE) \
		-dump-graph-DAG-before-compile=$(MODEL)-before.dot \
		-dump-graph-DAG=$(MODEL)-after.dot \
		-backend=CPU \
		--MO436Features=$(MO436Features) \
		-reuse-activation-memory-allocations=$(MEMOPT) \
		-dump-ir > $(MODEL).lir

clean:
	rm -f ${BUNDLE}/$(MODEL).o
