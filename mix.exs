defmodule ExOura.MixProject do
  use Mix.Project

  @version "1.0.0"
  @github_url "https://github.com/tgrk/ex_oura"

  def project do
    [
      app: :ex_oura,
      description: description(),
      package: package(),
      version: @version,
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      coverage: &coverage/1
    ]
  end

  defp coverage(_) do
    Mix.shell().cmd("MIX_ENV=test mix coveralls --color")
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.5"},
      {:mock, "~> 0.3.8", only: :test},
      {:exvcr, "~> 0.16", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, "~> 0.37", only: :dev, runtime: false},
      {:oapi_generator, "~> 0.2", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    An Elixir library for Oura API
    """
  end

  defp package do
    [
      name: "ex_oura",
      maintainers: ["Martin Wiso"],
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github_url,
        "Issues" => "https://github.com/tgrk/ex_oura/issues"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "ex_oura",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/ex_oura",
      source_url: @github_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end
end
