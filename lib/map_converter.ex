defmodule Lx.MapConverter do
  @moduledoc """
  Convert map, struct, http_parameters, atom_key_map
  """
  # If params is already string, returns it.
  # To judge string or not, is_binary(1) is a best practice in Elixir(crazy).
  def to_param_string(params) when is_binary(params) do
    case params do
      "" -> ""
      params -> "?" <> params
    end
  end

  # Convert atom_map to param_string
  # %{key1: value1, key2: value2} -> `?key1=value1&key2=value2&`
  def to_param_string(params) when is_map(params) do
    Map.to_list(params)
    |> Enum.filter(fn entry -> elem(entry, 0) != :__struct__ end)
    |> to_string_map()
    |> Enum.reduce(
      "?",
      fn header, acc ->
        acc <> elem(header, 0) <> "=" <> elem(header, 1) <> "&"
      end
    )
  end

  # Convert atom_map to string_map
  # %{key1: value1, key2: value2} -> %{"key1" => value1, "key2" => value2}
  defp to_string_map(map), do: for({k, v} <- map, into: %{}, do: {Atom.to_string(k), v})

  # Convert string_map to atom_map recursively.
  # %{
  #   "key1" => value1,
  #   "child" => %{"child_key1" => child_value2}
  # }
  #   ->
  # %{
  #   key1: value1,
  #   child: %{child_key1: => child_value2}
  # }
  def atomize(target) do
    is_struct = fn s -> is_map(s) && Map.has_key?(s, :__struct__) end
    key = fn k -> if(is_binary(k), do: String.to_atom(k), else: k) end
    value = fn v -> if(is_map(v) || is_list(v), do: atomize(v), else: v) end
    map = fn m -> if(is_struct.(m), do: Map.from_struct(m), else: m) end

    case target do
      nil -> nil
      x when is_list(x) -> Enum.map(x, &atomize(&1))
      x when is_map(x) -> for {k, v} <- map.(x), into: %{}, do: {key.(k), value.(v)}
      x -> x
    end
  end

  # Remove :__struct__ & :__meta__ from any map. You can encode with Jason easily.
  def remove_metadata(target) do
    is_struct = fn s -> is_map(s) && Map.has_key?(s, :__struct__) end
    value = fn v -> if(is_map(v) || is_list(v), do: remove_metadata(v), else: v) end

    map = fn m ->
      if(is_struct.(m), do: Map.from_struct(m), else: m)
      |> Enum.filter(fn {k, _} -> !String.match?(to_string(k), ~r/__.+__/) end)
    end

    case target do
      nil -> nil
      %DateTime{} = x -> DateTime.to_iso8601(x)
      x when is_list(x) -> Enum.map(x, &remove_metadata(&1))
      x when is_map(x) -> for {k, v} <- map.(x), into: %{}, do: {k, value.(v)}
      x -> x
    end
  end

  # Recursive filter.
  # ex) filter(fn {_, v} -> v != %{}  end)
  def filter(target, f) do
    value = fn v -> if(is_map(v) || is_list(v), do: filter(v, f), else: v) end
    map = fn m -> Enum.filter(m, f) end

    case target do
      nil -> nil
      x when is_list(x) -> Enum.map(x, &filter(&1, f))
      x when is_map(x) -> for {k, v} <- map.(x), into: %{}, do: {k, value.(v)}
      x -> x
    end
  end
end
