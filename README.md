# Vocab

[Flashcards](https://apps.apple.com/app/id307840670) is arguably the most flexible flashcards app that supports spaced repetition. This Elixir app helps building Flashcards-compatible files that then can imported into the app via iCloud drive.

<img width="678" alt="image" src="https://github.com/mxgrn/vocab/assets/33935/44f17fa7-6dad-4dc1-9ebd-5eb7efd0a358">

<img width="821" alt="image" src="https://github.com/mxgrn/vocab/assets/33935/24267279-0595-455f-adb8-708788e3a5ec">

The files will be created in the Flashcards folder on iCloud drive.

## How to run

### Get deps

    mix deps.get

### Generate the release

    mix phx.digest
    MIX_ENV=prod mix release

### Run the release

    PHX_SERVER=true SECRET_KEY_BASE=Mp7fEBRFRWeh1KXPzxTsvjFlVWIK9zIpRSRklaMdiN5k4M/MUlasj9ZrSo9BmEYG PORT=6001 DATABASE_URL=ecto://postgres:postgres@localhost/vocab_dev _build/prod/rel/vocab/bin/vocab start

## To run as a Tauri app

    cargo tauri dev
