defmodule MPF.MixProject do
  use Mix.Project

  def project do
    [
      app: :mpf,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    extra_applications = [:logger]

    case Mix.env() do
      :dev ->
        [
          mod: {MPF.Application, []},
          extra_applications: extra_applications ++ [:exsync]
        ]

      :test ->
        [
          mod: {MPF.Application, []},
          applications: [],
          extra_applications: extra_applications
        ]

      :prod ->
        [
          mod: {MPF.Application, []},
          extra_applications: extra_applications
        ]
    end
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true},
      {:exsync, "~> 0.2.3", only: :dev},
      {:floki, "~> 0.20.0"},
      {:httpoison, "~> 1.5"},
      {:html5ever, "~> 0.6.1"},
    ]
  end
end
