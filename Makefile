REVISION=`git rev-parse HEAD`

build:
	docker build --no-cache --tag cuenta-application --build-arg REVISION=$(REVISION) .

dev-build:
	docker build --tag cuenta-application --build-arg REVISION=$(REVISION) .

up_db:
	docker-compose up -d kong-database cuenta-database

setup_db:
	docker-compose run --rm cuenta-application mix ecto.setup

up_app: up_cuenta-app up_kong-app

up_cuenta-app:
	docker-compose up -d cuenta-application

up_kong-app:
	docker-compose up -d kong-application
