defmodule Git2pdf.MixProject do
  use Mix.Project

  def project do
    [
      app: :git2pdf,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Git2PDF",
      source_url: "https://github.com/madawei2699/git2pdf"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "print github nested markdown file all in one pdf"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:pdf_generator, ">=0.4.0" },
      {:floki, "~> 0.20.0"},
      {:httpoison, "~> 1.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "git2pdf",
      # These are the default files included in the package
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/madawei2699/git2pdf"}
    ]
  end
end
