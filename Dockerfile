FROM msaraiva/elixir-gcc:1.3.1
ENV MIX_ENV=prod
RUN apk --no-cache --update add mariadb-client
RUN mix do local.hex --force, local.rebar --force
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock
WORKDIR /app
RUN mix deps.get --only prod
COPY . /app
RUN mix compile
RUN apk del --purge gcc make libc-dev libgcc && rm -rf /var/cache/apk/*
CMD ["mix", "phoenix.server"]
ARG REVISION
LABEL revision=$REVISION maintainer="Nee-co"
