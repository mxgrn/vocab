defmodule VocabWeb.Router do
  use VocabWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VocabWeb do
    pipe_through :browser

    get "/", DeckController, :index
    get "/decks/locate", DeckController, :locate

    resources "/decks", DeckController do
      resources "/entries", EntryController, only: [:index, :new, :create, :show]
    end

    resources "/entries", EntryController, only: [:edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", VocabWeb do
  #   pipe_through :api
  # end
end
