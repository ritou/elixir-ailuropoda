defmodule Ailuropoda.Mixfile do
  use Mix.Project

  def project do
    [app: :ailuropoda,
     version: "0.1.1",
     elixir: "~> 1.3",
     # build_embedded: Mix.env == :prod,
     # start_permanent: Mix.env == :prod,
     description: "Ailuropoda is Chinese Personal ID Card Validator for Elixir.",
     package: [
       maintainers: ["Ryo Ito"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/ritou/elixir-ailuropoda"}
     ],
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
