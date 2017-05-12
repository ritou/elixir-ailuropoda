defmodule Ailuropoda.Mixfile do
  use Mix.Project

  def project do
    [app: :ailuropoda,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :gb2260]]
  end

  defp deps do
    [
      {:gb2260, "~> 0.6.1"},
      {:ex_doc, "~> 0.10", only: :dev}
    ]
  end
end
