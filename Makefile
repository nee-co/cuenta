REVISION=`git rev-parse HEAD`

build:
	docker build --no-cache --tag cuenta-application --build-arg REVISION=$(REVISION) .
