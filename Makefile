REVISION = `git rev-parse HEAD`

.PHONY: image db app volumes networks

image:
	docker build --tag cuenta-application --build-arg REVISION=$(REVISION) .

db:
	docker-compose up -d cuenta-database

app:
	docker-compose run -p 4000:4000 cuenta-application ash

volumes:
	@docker volume create --name neeco_public || true

networks:
	@docker network create neeco_cuenta-imagen || true
	@docker network create neeco_kong-cuenta || true
