defmodule Vocab do
  @moduledoc """
  Vocab keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def deck_filepath, do: Application.get_env(:vocab, :deck_filepath)
end
