FROM registry.neec.xyz/neeco/elixir:1.3.4
ENV MIX_ENV=prod
RUN apk add --no-cache --update mariadb-client && \
    apk add --no-cache --virtual build-dependencies \
    gcc \
    make \
    libc-dev \
    libgcc && \
    mix do local.hex --force, local.rebar --force
COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock
WORKDIR /app
RUN mix deps.get --only prod
COPY . /app
RUN mix compile && \
    apk del --purge build-dependencies && \
    rm -rf /var/cache/apk/*
CMD ["mix", "phoenix.server"]
ARG REVISION
LABEL revision=$REVISION maintainer="Nee-co"
