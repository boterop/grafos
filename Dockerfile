FROM elixir:1.17.3 as builder
WORKDIR /usr/src/app

ARG MIX_ENV=dev
ENV MIX_ENV=${MIX_ENV}

RUN apt-get update && apt-get install -y inotify-tools

COPY mix.exs ./

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

COPY . .

RUN mix do phx.digest, compile

EXPOSE 4000
RUN if [ "$MIX_ENV" = "prod" ]; then mix release; else mix start; fi

FROM elixir:1.17.3 as runner
WORKDIR /usr/src/app

ARG APP_NAME
ENV APP_NAME=${APP_NAME}

RUN apt-get update && apt-get install -y inotify-tools

COPY --from=builder /usr/src/app/_build/prod/rel/${APP_NAME} ./

CMD ["bin/${APP_NAME}", "start"]