# Git2pdf

## Description

Git2PDF is a simple parser which can make github nested markdown file all in one PDF.

## Notice

Parse a markdown file which has a lot of url links can lead a very long time to make a PDF. The reason is Git2PDF need check every url status, if one links is broken which can throw a exception by **wkhtmltopdf** and it will faliure. One another is it need sleep random senconds for github anti-crawler strategy.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `git2pdf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:git2pdf, "~> 0.1.0"}
  ]
end
```

## How to use

```iex> GitHubParse.markdown_to_pdf "https://github.com/CyC2018/CS-Notes/blob/master/README.md"```


## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/git2pdf](https://hexdocs.pm/git2pdf).

