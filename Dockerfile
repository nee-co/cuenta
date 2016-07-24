FROM msaraiva/elixir-dev:1.3.1
MAINTAINER Nee-co
RUN apk --no-cache --update add mariadb-client
ADD . /app
WORKDIR /app
ENV MIX_ENV=prod
RUN mix do deps.get --only prod, compile
CMD ["mix", "phoenix.server"]