defmodule ServeElm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :serve_elm,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ServeElm.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {
        :phoenix,
       git: "git@github.com:phoenixframework/phoenix",
       branch: "master",
       override: true
      },
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:execjs, git: "git@github.com:robotarmy/execjs.git", branch: "master"},
      {:cowboy, "~> 2.1", override: true},
      {:plug, "~> 1.5-rc0", override: true},
      {:json_web_token, "~> 0.2.5"},
      { :uuid, "~> 1.1" } 
    ]
  end
end
