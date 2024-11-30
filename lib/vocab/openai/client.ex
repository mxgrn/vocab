defmodule Vocab.Openai.Client do
  @moduledoc false
  require Logger

  def chat_completion(messages, model \\ "gpt-4") do
    Req.post("https://api.openai.com/v1/chat/completions",
      json: %{
        model: model,
        messages: messages
      },
      headers: headers()
    )
  end

  def list_models do
    Req.get("https://api.openai.com/v1/models", headers: headers())
  end

  # def translate(text, source_language, target_language) do
  #   messages = [
  #     %{
  #       role: "system",
  #       content:
  #         "You are a professional translator. Your task is to translate the given text from #{source_language} to #{target_language}."
  #     },
  #     %{role: "user", content: text}
  #   ]
  #
  #   messages
  #   |> chat_completion()
  #   |> extract_response()
  # end

  def translate(text, _model \\ "gpt-3.5-turbo") do
    messages = [
      %{
        role: "system",
        # ~s[You act like an English-Russian dictionary. I give you an English word (the source word), and you return me just a stripped-down, plain-text file, whith 3 paragraphs: 1) the translation to Russian with a couple of synonyms, 2) the American transcription of the source word, and 3) 2 simple English sentences that show how the English word is being used, separated by a single new-line. Make sure that examples correspond to the returned translation. Don't include *any* text other than what I specified - just simple 3 paragraphs, separated by double-new-line.]
        content:
          ~s[You act like an English-Russian dictionary. I give you an English word (the source word), and you return me just a stripped-down, plain-text file, whith 3 paragraphs separated by double-new-line: 1) the translation to Russian with a couple of synonyms, 2) the American transcription of the source word, and 3) 2 simple English sentences separated by a single new-line (not a numbered list) that show how the English word is being used. Make sure that examples correspond to the returned translation. Don't include any text other than what I specified.]
      },
      %{role: "user", content: text}
    ]

    messages
    |> chat_completion()
    |> extract_response()
  end

  defp extract_response(api_response) do
    case api_response do
      {:ok, response} ->
        Logger.info("OpenAI response: #{inspect(response)}")

        content =
          response.body["choices"]
          |> List.first()
          |> Map.get("message")
          |> Map.get("content")

        {:ok, content}

      error ->
        Logger.info("OpenAI error: #{inspect(error)}")
        error
    end
  end

  defp headers do
    [
      {"Authorization", "Bearer #{Application.get_env(:vocab, :openai)[:api_key]}"}
    ]
  end
end
