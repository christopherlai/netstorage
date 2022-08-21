defmodule NetStorage.MixProject do
  @name :netstorage
  @version "0.2.0"

  use Mix.Project

  def project do
    [
      app: @name,
      version: @version,
      description: "Akamai NetStorage API wrapper",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      name: @name,
      licenses: ["mit"],
      links: %{"GitHub" => "https://github.com/christopherlai/netstorage"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:hackney, "~> 1.18"},
      {:sweet_xml, "~> 0.7.3"}
    ]
  end
end
