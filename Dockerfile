ARG ELIXIR_VERSION=1.17.3
ARG OTP_VERSION=27

FROM elixir:${ELIXIR_VERSION} AS builder
WORKDIR /app

ARG MIX_ENV=dev
ENV MIX_ENV=${MIX_ENV}

RUN apt-get update && apt-get install -y inotify-tools
RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.exs mix.lock ./

RUN mix deps.get --only $MIX_ENV

COPY . .

RUN mix do assets.deploy, phx.digest, compile

EXPOSE 4000
RUN if [ "$MIX_ENV" = "prod" ]; then mix release; else mix start; fi

FROM elixir:${ELIXIR_VERSION} AS runner
WORKDIR /app
RUN chown nobody /app

ARG APP_NAME
ENV APP_NAME=${APP_NAME}

COPY --from=builder /app/_build/prod/rel/${APP_NAME} ./

USER nobody

CMD ["/app/bin/server"]
