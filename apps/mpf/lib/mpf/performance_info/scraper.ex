defmodule MPF.PerformanceInfo.Scraper do
  alias HTTPoison.{Error, Response}
  alias MPF.PerformanceInfo.Parser

  def scrape_mpf_performance_summaries() do
    with {:ok, html} <- fetch_fund_performance_summaries_html() do
      {:ok, html |> Parser.parse_fund_performance_summaries()}
    end
  end

  defp fetch_fund_performance_summaries_html() do
    case HTTPoison.get("https://fpp.mpfa.org.hk/english/mpp_list.jsp") do
      {:ok, %Response{body: body}} -> {:ok, body}
      {:error, %Error{reason: reason}} -> {:error, reason}
    end
  end
end
