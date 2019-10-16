defmodule ExOuraring.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ouraring,
      description: description(),
      package: package(),
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :oauth2]
    ]
  end

  defp deps do
    [
      {:oauth2, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:timex, "~> 3.6"},

      # Build & test tools
      {:credo, "~> 1.0", only: :dev},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev},
      {:exvcr, "~> 0.10", only: :test},
    ]
  end

  defp description() do
    """
    ExOuraring - Elixir client for Oura Ring API
    """
  end

  defp package() do
    [
      files: [
        "config",
        "lib",
        "LICENSE",
        "mix.exs",
        "README.md"
      ],
      maintainers: ["Martin Wiso"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/tgrk/exouraring",
        "Issues" => "https://github.com/tgrk/exouraring/issues"
      }
    ]
  end
end
