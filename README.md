# Vocab

[Flashcards](https://apps.apple.com/app/id307840670) is arguably the most flexible flashcards app that supports spaced repetition.

This Elixir app, running in a browser, helps building Flashcards-compatible .txt-files that then can easily be imported into the mobile app via iCloud drive.

## Main features

- On-the-fly creation and updating of .txt files on the iCloud disk, one per card deck, in the Flashcards folder.
- Each cards supports the following fields:
    - source - word/phrase to be translated
    - translation
    - transcription (optional) - transcription in the learnt language
    - examples (optional) - one or more examples that show possible usage of both cards (can include both languages).
    The transcription, if provided, gets automatically prepended on the flipside of the card in Flashcards.The examples, if provided, get automatically apended on the flipside.
- Creation of a "reverse" card, where source and translation are swapped. To enable this feature, assign a reverse deck to any given deck first.

## Planned work

- Package into a [Tauri](https://github.com/tauri-apps/tauri) app to be distributed as a .dmg installer.

## Screenshots

<img width="678" alt="image" src="https://github.com/mxgrn/vocab/assets/33935/44f17fa7-6dad-4dc1-9ebd-5eb7efd0a358">

<img width="765" alt="image" src="https://github.com/mxgrn/vocab/assets/33935/8f026452-b1ed-4b9a-a394-d0f6caca3160">

## How to build and run the release

### 1. Get deps

    mix deps.get

### 2. Setup DB

    DATABASE_URL=ecto://postgres:postgres@localhost/vocab MIX_ENV=prod mix ecto.setup

### 2.5 Compile assets

    MIX_ENV=prod mix assets.deploy

### 3. Generate the release

    OPENAI_API_KEY=insert-your-key MIX_ENV=prod mix release

### 4. Run the release

> Note that you can assign a different port if needed.

    PORT=6001 DATABASE_URL=ecto://postgres:postgres@localhost/vocab _build/prod/rel/vocab/bin/vocab start

### 5. Open in browser

Browse to http://localhost:6001
