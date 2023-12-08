# Vocab

## How to run

### Get deps

    mix deps.get

### Generate the release

    mix phx.digest
    MIX_ENV=prod mix release

### Run the release

    PHX_SERVER=true SECRET_KEY_BASE=Mp7fEBRFRWeh1KXPzxTsvjFlVWIK9zIpRSRklaMdiN5k4M/MUlasj9ZrSo9BmEYG PORT=6001 DATABASE_URL=ecto://postgres:postgres@localhost/vocab_dev _build/prod/rel/vocab/bin/vocab start
