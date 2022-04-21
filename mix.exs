defmodule Flexto.MixProject do
  use Mix.Project

  def project do
    [
      app: :flexto,
      version: "0.2.3",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: "Hack ecto schemas after the fact.",
      homepage_url: "https://github.com/commonspub/flexto",
      source_url: "https://github.com/commonspub/flexto",
      package: [
        licenses: ["Apache 2"],
        links: %{
          "Repository" => "https://github.com/bonfire-networks/flexto",
          "Hexdocs" => "https://hexdocs.pm/flexto",
        },
      ],
      docs: [
        main: "readme", # The first page to display from the docs
        extras: ["README.md"], # extra pages to include
      ],
      deps: deps()
    ]
  end

  def application, do: [ extra_applications: [:logger] ]

  defp deps do
    [
      {:ecto, "~> 3.0"},
      # {:ecto_sql, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end
end
