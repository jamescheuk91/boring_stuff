defmodule MPF.PerformanceInfo.FundPerformanceSummary do
  @moduledoc """
  A struct representing a FundPerformanceSummary.
  """
  use TypedStruct

  @typedoc "A FundPerformanceSummary"
  typedstruct do
    field(:scheme, String.t(), enforce: true)
    field(:constituent_fund, String.t(), enforce: true)
    field(:mpf_trustee, String.t(), enforce: true)
    field(:mpf_trustee_code, String.t(), enforce: true)
    field(:fund_type, String.t(), enforce: true)
    field(:launch_date, Date.t(), enforce: true)
    # % p.a of NAV
    field(:current_management_fee_percentage, float(), enforce: true)
    field(:latest_fer_percentage, float())
    field(:fund_size_in_hkd, float())
    field(:fund_risk_indicator_percentage, float())
    # % p.a
    field(:one_year_annualized_return_percentage, float())
    # % p.a
    field(:five_years_annualized_return_percentage, float())
    # % p.a
    field(:ten_years_annualized_return_percentage, float())
    # annualized return percentage since launch
    field(:annualized_return_percentage, float())
  end
end
