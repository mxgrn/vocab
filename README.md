# Vocab

## Todo

  - Fix live page reload
  - Fix tests

## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:6001`](http://localhost:6001) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## How to run release

    PHX_SERVER=true SECRET_KEY_BASE=Mp7fEBRFRWeh1KXPzxTsvjFlVWIK9zIpRSRklaMdiN5k4M/MUlasj9ZrSo9BmEYG PORT=6001 DATABASE_URL=ecto://postgres:postgres@localhost/vocab_dev /Users/mxgrn/code/mxgrn/vocab/_build/prod/rel/vocab/bin/vocab start

## How to run via Docker

    docker run -e PHX_SERVER=true -e SECRET_KEY_BASE=Mp7fEBRFRWeh1KXPzxTsvjFlVWIK9zIpRSRklaMdiN5k4M/MUlasj9ZrSo9BmEYG -e DATABASE_URL=ecto://postgres:postgres@host.docker.internal/vocab_dev -p 6001:4000 elixir/vocab

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
