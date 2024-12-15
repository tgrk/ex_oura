defmodule ExOura.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_oura,
      version: "0.1.0",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
      {:req, "~> 0.5.8"},
      {:exvcr, "~> 0.15.2", only: :test},
      {:oapi_generator, "~> 0.2.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mock, "~> 0.3.8", only: :test},
      {:excoveralls, "~> 0.18.3", only: :test}
    ]
  end
end
