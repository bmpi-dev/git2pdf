defmodule GitHubParse do

  @moduledoc """
  Git2PDF is a simple parser which can make github nested markdown file all in one PDF.
  """

  @doc """
  ## Example
    iex> GitHubParse.markdown_to_pdf "https://github.com/remoteintech/remote-jobs/blob/master/README.md", 2, false
    url is https://github.com/CyC2018/CS-Notes/blob/master/README.md
    check_url_status: url is https://xiaozhuanlan.com/CyC2018
    check_url_status: url is https://github.com/CyC2018/CS-Notes/blob/master/other/LogoMakr_0zpEzN.png
    check_url_status: url is https://github.com/CyC2018/CS-Notes/raw/master/other/LogoMakr_0zpEzN.png
    check_url_status: url is https://cyc2018.github.io/CS-Notes

  """
  def markdown_to_pdf(url, deep_level, is_check_url) do
    readme_html = url_to_html(url, false, deep_level, is_check_url)
    pdf_file_path = PdfGenerator.generate! readme_html, shell_params: ["--encoding", "utf-8"]
    html_file_path = Enum.at(String.split(pdf_file_path, "."), 0) <> ".html"
    File.write!(html_file_path, readme_html)
    {html_file_path, pdf_file_path}
  end

  defp get_html_body(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      _ ->
        ""
    end
  end

  defp url_to_html(url, is_readme, deep_level, is_check_url, url_list \\ [])

  defp url_to_html(url, is_readme, deep_level, is_check_url, url_list) when deep_level > 0 do
    IO.puts("url is #{url}")
    # must include else clause or it will nil
    url_list = if length(url_list) == 0 do List.insert_at(url_list, 0, url) else url_list end
    Process.sleep(Enum.random(1..2) * 500)
    body = get_html_body(url)
    readme =
      if is_readme do
        Enum.at(Floki.find(body, "#readme div"), 1)
      else
        Floki.find(body, "#readme")
      end
    normal_html =
      if is_readme do
        walk_html_node(readme, is_check_url)
      else
        walk_html(readme, is_check_url)
      end
    new_url_list = Floki.find(normal_html, "a") |> Floki.attribute("href") |> Enum.filter(fn x -> String.contains?(x, ".md") and not String.contains?(x, ".md#") end)
    IO.puts("new url list is #{new_url_list}")
    child_htmls = new_url_list
      |> Stream.filter(fn x -> not Enum.member?(url_list, x) end)
      |> Stream.map(&url_to_html(&1, false, deep_level - 1, is_check_url, Enum.concat(new_url_list, url_list)))
      |> Enum.to_list
    [Floki.raw_html(flatten_list(normal_html)) | child_htmls]
  end

  defp url_to_html(_, _, deep_level, _, _) when deep_level == 0 do
    []
  end

  defp flatten_list(list) do
    case list do
      [[l]] -> [l]
      other -> other
    end
  end

  defp walk_html(html, is_check_url) do
    html
    |>Enum.map(&walk_html_node(&1, is_check_url))
    |>Enum.to_list
  end

  defp walk_html_node(node, is_check_url) do
    case node do
      {tag, attribute_list, child_node_list} -> {tag, walk_html_attr(attribute_list, is_check_url), walk_html_node(child_node_list, is_check_url)}
      list when is_list(list) -> walk_html(list, is_check_url)
      _ -> node
    end
  end

  defp walk_html_attr(attr_list, is_check_url) do
    attr_list
    |>Enum.map(fn(item) -> fix_url(item, is_check_url) end)
    |>Enum.to_list
  end

  defp fix_url({name, value}, is_check_url) do
    case name do
      "src" -> if not String.starts_with?(value, "http") and not String.starts_with?(value, "#") do {name,  check_url_status("https://github.com" <> value, is_check_url)} else {name, check_url_status(value, is_check_url)} end
      "href" -> if not String.starts_with?(value, "http") and not String.starts_with?(value, "#") do {name, check_url_status("https://github.com" <> value, is_check_url)} else {name, check_url_status(value, is_check_url)} end
      _ -> {name, value}
    end
  end

  defp check_url_status(url, is_check_url) when is_check_url == false do
    url
  end

  defp check_url_status(url, is_check_url) when is_check_url == true do
    if (String.starts_with?(url, "http")) do
      IO.puts("check_url_status: url is #{url}")
      Process.sleep(500)
      r = HTTPoison.head url
      case r do
        {:ok, %HTTPoison.Response{status_code: 404, body: _}} ->
          IO.puts "url is null"
        _ ->
          url
      end
    else
      ""
    end
  end
end
