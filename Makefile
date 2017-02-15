.PHONY: db app network

db:
	docker-compose up -d cuenta-database

app:
	docker-compose run -p 4000:4000 cuenta-application ash

network:
	@docker network create neeco_develop || true
