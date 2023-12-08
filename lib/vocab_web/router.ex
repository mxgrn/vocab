defmodule VocabWeb.Router do
  use VocabWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VocabWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VocabWeb do
    pipe_through :browser

    live "/", DeckLive.Index, :index

    live "/decks", DeckLive.Index, :index
    live "/decks/new", DeckLive.Index, :new
    live "/decks/:id/edit", DeckLive.Index, :edit

    live "/decks/:id", DeckLive.Show, :show
    live "/decks/:id/show/edit", DeckLive.Show, :edit

    live "/decks/:deck_id/entries", EntryLive.Index, :index
    live "/decks/:deck_id/entries/new", EntryLive.Index, :new
    live "/entries/:id/edit", EntryLive.Index, :edit

    live "/entries/:id", EntryLive.Show, :show
    live "/entries/:id/show/edit", EntryLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", VocabWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vocab, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VocabWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
