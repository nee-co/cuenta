FROM msaraiva/elixir-gcc:1.3.1
MAINTAINER Nee-co
ENV MIX_ENV=prod
RUN apk --no-cache --update add mariadb-client
COPY . /app
WORKDIR /app
RUN mix do deps.get --only prod, compile
RUN apk del --purge gcc make libc-dev libgcc && rm -rf /var/cache/apk/*
CMD ["mix", "phoenix.server"]
