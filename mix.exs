defmodule TicketToRide.Mixfile do
  use Mix.Project

  def project do
    [app:               :ticket_to_ride,
     version:           "0.0.1",
     elixir:            "~> 1.3",
     elixirc_paths:     elixirc_paths(Mix.env),
     compilers:         [:phoenix] ++ Mix.compilers,
     build_embedded:    Mix.env == :prod,
     start_permanent:   Mix.env == :prod,
     test_coverage:     [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test],
     deps:              deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {TicketToRide, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      { :phoenix,              "~> 1.0"                },
      { :phoenix_ecto,         "~> 1.2.0"              },
      { :postgrex,             ">= 0.0.0"              },
      { :phoenix_html,         "~> 2.0"                },
      { :phoenix_live_reload,  "~> 1.0",   only: :dev  },
      { :cowboy,               "~> 1.0"                },
      { :excoveralls,          "~> 0.3",   only: :test },
    ]
  end
end
