FROM msaraiva/elixir-dev:1.3.1
MAINTAINER Nee-co

RUN apk --nocahe --update add mariadb-client

RUN mkdir /app
WORKDIR /app
ADD mix.exs /app/mix.exs
ADD mix.lock /app/mix.lock

RUN mix deps.get && mix deps.compile
