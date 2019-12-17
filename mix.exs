defmodule Lx.MixProject do
  use Mix.Project

  def project do
    [
      app: :lx,
      version: "1.0.5",
      elixir: "~> 1.9",
      description: "Lavans eliXir utilities",
      package: [
        maintainers: ["Masayuki.D"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/lavans/lx"
        }
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
