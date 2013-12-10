CWD ?= $(shell pwd)

all:
	sed -e 's:<currentpath>:$(CWD):g' params.tmp > params.txt
	sed -e 's:<currentpath>:$(CWD):g' config.SFs.tmp > config.SFs 

