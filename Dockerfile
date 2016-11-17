FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix local.hex --force && mix do deps.get, deps.compile

RUN apk --update --no-cache add python mysql-client

# Same with npm deps
ADD package.json package.json
RUN npm install

ADD . .

# Run frontend build, compile, and digest assets
RUN brunch build --production && \
    mix do compile, phoenix.digest

# USER default

CMD ["mix", "phoenix.server"]
