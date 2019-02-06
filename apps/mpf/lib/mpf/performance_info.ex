defmodule MPF.PerformanceInfo do
  alias MPF.PerformanceInfo.Scraper

  def generate_performance_summaries_csv() do
    with {:ok, performance_summaries} <- Scraper.scrape_mpf_performance_summaries(),
         {:ok, file} <- File.open("performance_summaries_31_12_2018.csv", [:write, :utf8]) do
      headers = [
        :scheme,
        :constituent_fund,
        :mpf_trustee,
        :mpf_trustee_code,
        :fund_type,
        :launch_date,
        :current_management_fee_percentage,
        :latest_fer_percentage,
        :fund_size_in_hkd,
        :fund_risk_indicator_percentage,
        :one_year_annualized_return_percentage,
        :five_years_annualized_return_percentage,
        :ten_years_annualized_return_percentage,
        :annualized_return_percentage
      ]

      performance_summaries
      |> CSV.encode(headers: headers)
      |> Enum.each(&IO.write(file, &1))
    end
  end
end
