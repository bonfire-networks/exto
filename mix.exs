defmodule Exto.MixProject do
  use Mix.Project

  def project do
    [
      app: :exto,
      version: "0.4.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: "Extend ecto schema definitions in config",
      homepage_url: "https://github.com/bonfire-networks/exto",
      source_url: "https://github.com/bonfire-networks/exto",
      package: [
        licenses: ["Apache 2"],
        links: %{
          "Repository" => "https://github.com/bonfire-networks/exto",
          "Hexdocs" => "https://hexdocs.pm/exto"
        }
      ],
      docs: [
        # The first page to display from the docs
        main: "readme",
        # extra pages to include
        extras: ["README.md"]
      ],
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:accessible, "~> 0.3.0"},
      # {:ecto_sql, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
