# Git2pdf

## Description

Git2PDF is a simple parser which can make github nested markdown file all in one PDF.

## Notice

Parse a markdown file which has a lot of url links can lead a very long time to make a PDF. The reason is Git2PDF need check every url status, if one links is broken which can throw a exception by **wkhtmltopdf** and it will faliure. One another is it need sleep 500ms every url check for github anti-crawler strategy.

## Installation

before you can use this lib, it need install **wkhtmltopdf** to parse html to pdf, install guid can found its [website](https://wkhtmltopdf.org/)

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

```iex> GitHubParse.markdown_to_pdf "https://github.com/madawei2699/git2pdf/blob/master/README.md", 2, false```
```{"/var/folders/k7/w1zkb4cn0472dk8t_j699pyc0000gn/T/KXiE8hJZ.html", "/var/folders/k7/w1zkb4cn0472dk8t_j699pyc0000gn/T/KXiE8hJZ.pdf"}```

The first is url, sencond is deep_level which mean how deepth which you want it get, the last is whether it check every url in markdown, mostly it doesn't need to check and you don't want to wait too long time.

[Change Log](CHANGELOG.md)