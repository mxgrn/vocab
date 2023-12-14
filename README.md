# Vocab

[Flashcards](https://apps.apple.com/app/id307840670) is arguably the most flexible flashcards app that supports spaced repetition.

This Elixir app, running in a browser, helps building Flashcards-compatible .txt-files that then can easily be imported into the mobile app via iCloud drive.

## Main features

- On-the-fly creation and updating of .txt files on the iCloud disk, one per card deck, in the Flashcards folder.
- Each cards supports 3 fields: source, translation, and pronunciation. The pronunciation gets automatically pre-pended to the flipside of the card in Flashcards.
- Creation of a "reverse" card, where source and translation are swapped. To enable this feature, assign a reverse deck to any given deck first.

## Planned work

- Package into a [Tauri](https://github.com/tauri-apps/tauri) app to be distributed as a .dmg installer.
- Add support for examples (the optional "3rd side" of a Flashcards card).

## Some screenshots

<img width="678" alt="image" src="https://github.com/mxgrn/vocab/assets/33935/44f17fa7-6dad-4dc1-9ebd-5eb7efd0a358">

<img width="841" alt="image" src="https://github.com/mxgrn/vocab/assets/33935/7b7a49f3-0aa5-46b2-9540-0ccb3dc3ccdc">

## How to run

### Get deps

    mix deps.get

### Setup DB

    mix ecto.setup

### Generate the release

    mix phx.digest
    MIX_ENV=prod mix release

### Run the release

    PHX_SERVER=true SECRET_KEY_BASE=Mp7fEBRFRWeh1KXPzxTsvjFlVWIK9zIpRSRklaMdiN5k4M/MUlasj9ZrSo9BmEYG PORT=6001 DATABASE_URL=ecto://postgres:postgres@localhost/vocab_dev _build/prod/rel/vocab/bin/vocab start
