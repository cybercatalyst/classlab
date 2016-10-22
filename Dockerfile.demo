FROM elixir:latest

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    postgresql  \
    postgresql-contrib  \
    git \
    postgresql-client-9.4 \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo %sudo    ALL=NOPASSWD: ALL>>/etc/sudoers

RUN useradd -m -G sudo app

RUN mkdir /phoenixapp
WORKDIR /phoenixapp

COPY ./mix.exs /phoenixapp/mix.exs
COPY ./mix.lock /phoenixapp/mix.lock
RUN yes | mix local.hex --force && mix deps.get

COPY ./package.json /phoenixapp/package.json
RUN yes | npm install

COPY ./ /phoenixapp

ENV PORT 8080
ENV MIX_ENV demo

RUN mkdir -p priv/static
RUN node_modules/brunch/bin/brunch build --production
RUN mix phoenix.digest
RUN mix deps.compile
RUN mix compile

EXPOSE 8080

ENTRYPOINT /phoenixapp/scripts/start-server.sh
