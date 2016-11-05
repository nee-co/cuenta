REVISION = `git rev-parse HEAD`

.PHONY: image up_db up_app setup_db volumes networks import_default-files

image:
	docker build --tag cuenta-application --build-arg REVISION=$(REVISION) .

up_db:
	docker-compose up -d cuenta-database

up_app:
	docker-compose up -d cuenta-application

setup_db:
	docker-compose run --rm cuenta-application mix ecto.setup

volumes:
	@docker volume create --name neeco_cuenta || true
	@docker volume create --name neeco_public || true

networks:
	@docker network create neeco_cuenta || true
	@docker network create neeco_kong-cuenta || true

import_default-files: volumes
	docker run --rm -i -v neeco_public:/work cuenta-application ash -c "cd /app/uploads/ && cp -r --parents images/users/defaults /work/"
