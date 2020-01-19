defmodule Vocab.Repo do
  use Ecto.Repo,
    otp_app: :vocab,
    adapter: Ecto.Adapters.Postgres
end
