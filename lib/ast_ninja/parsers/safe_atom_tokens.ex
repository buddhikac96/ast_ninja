defmodule AstNinja.Parsers.SafeAtomTokens do
  import AstNinja.Parsers

  def parse(code, _options) do
    opts = [existing_atoms_only: :safe]

    {result, warnings} =
      gather_warnings(fn -> :elixir.string_to_tokens(to_charlist(code), 0, "main", opts) end)

    metadata = %{atom_count: :erlang.system_info(:atom_count)}

    case result do
      {:ok, data} ->
        %{
          code: pretty(data),
          metadata: metadata,
          warnings: warnings
        }

      {:error, {_, message, x}} ->
        %{error: [message, x], metadata: metadata}

      {:error, _} ->
        %{error: "Tokenize error"}
    end
  end
end
