defmodule MPF.PerformanceInfo.ScraperTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias MPF.PerformanceInfo.Scraper
  alias MPF.PerformanceInfo.FundPerformanceSummary

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    HTTPoison.start()
    :ok
  end

  test "scrape_mpf_performance_summaries/0" do
    use_cassette "get_mpp_list" do
      {:ok, [%FundPerformanceSummary{} = summary1 | _]} = Scraper.scrape_mpf_performance_summaries()
      assert summary1.scheme
      assert summary1.constituent_fund
      assert summary1.mpf_trustee
      assert summary1.mpf_trustee_code
      assert summary1.fund_type
      assert summary1.launch_date
    end
  end
end
