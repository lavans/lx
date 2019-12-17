defmodule LxParam do
  defstruct [:id, :name]
end

defmodule LxTest do
  use ExUnit.Case
  alias Lx.MapConverter

  test "remove_metadata" do
    param = %LxParam{id: 1, name: "John"}
    assert is_struct?(param)

    removed = MapConverter.remove_metadata(param)
    assert !is_struct?(removed)
  end

  defp is_struct?(x), do: Map.has_key?(x, :__struct__)

  test "remove_empty_map" do
    result =
      %LxParam{id: 1, name: %{}}
      |> MapConverter.remove_metadata()
      |> MapConverter.filter(fn {_, v} -> v != %{} end)
      |> inspect
    assert !String.contains?(result, "{}")
  end
end


