# MapConverter

### to_param_string/1
Convert atom_map to param_string
```elixir:to_param_string/1
%{key1: value1, key2: value2}
```
  ↓
```
"?key1=value1&key2=value2&"
```

### atomize
Convert string_map to atom_map recursively.
```elixir:MapConverter.atomize/1
%{
  "key1" => "value1",
  "child" => %{"child_key1" => "child_value2"}
}
```
  ↓
```
%{
  key1: "value1",
  child: %{child_key1: "child_value2"}
}
``` 


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lx, "~> 1.0.5"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lx](https://hexdocs.pm/lx).

