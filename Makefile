REVISION = `git rev-parse HEAD`

.PHONY: images dev-images up_db up_app volumes networks import_default-files

image:
	docker build --no-cache --tag cuenta-application:$(REVISION) .

dev-image:
	docker build --tag cuenta-application:$(REVISION) .

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
	docker run --rm -it -v neeco_cuenta:/work cuenta-application cp -r /app/uploads/images/ /work/
