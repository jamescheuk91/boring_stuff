defmodule MPF.PerformanceInfo.Parser do
  alias MPF.PerformanceInfo.FundPerformanceSummary

  def parse_fund_performance_summaries(html) do
    html
    |> Floki.find("tbody#tableContent tr")
    |> Enum.map(&remove_tr_nested_linkbreak_elements/1)
    |> Enum.map(&extract_performance_summary/1)
  end

  defp remove_tr_nested_linkbreak_elements({"tr", attrs, nested_elements}) do
    updated_nested_elements =
      nested_elements
      |> Enum.map(&remove_tr_nested_linkbreak_element/1)
      |> Enum.filter(& &1)

    {"tr", attrs, updated_nested_elements}
  end

  defp remove_tr_nested_linkbreak_element(text) when is_binary(text), do: nil

  defp remove_tr_nested_linkbreak_element(element), do: element

  defp extract_performance_summary(
         {"tr", _attrs,
          [
            _,
            {"td", _, [scheme]},
            _,
            {"td", _, [constituent_fund]},
            {"td", _, [{"div", [_, {"title", mpf_trustee}], [mpf_trustee_code]}]},
            {"td", _, [fund_type]},
            {"td", _, [launch_date_text]},
            {"td", _, [current_management_fee_percentage_text]},
            {"td", _, [latest_fer_percentage_text]},
            {"td", _, [fund_size_text]},
            {"td", _, [fund_risk_indicator_percentage_text]},
            {"td", _, [one_year_annualized_return_percentage_text]},
            {"td", _, [five_years_annualized_return_percentage_text]},
            {"td", _, [ten_years_annualized_return_percentage_text]},
            {"td", _, [since_launch_annualized_return_percentage_text]} | _
          ]}
       ) do
    [
      current_management_fee_percentage,
      latest_fer_percentage,
      fund_risk_indicator_percentage,
      one_year_annualized_return_percentage,
      five_years_annualized_return_percentage,
      ten_years_annualized_return_percentage,
      since_launch_annualized_return_percentage
    ] =
      [
        current_management_fee_percentage_text,
        latest_fer_percentage_text,
        fund_risk_indicator_percentage_text,
        one_year_annualized_return_percentage_text,
        five_years_annualized_return_percentage_text,
        ten_years_annualized_return_percentage_text,
        since_launch_annualized_return_percentage_text
      ]
      |> Enum.map(&String.trim/1)
      |> Enum.map(&convert_percentage_to_float/1)

    %FundPerformanceSummary{
      scheme: scheme,
      constituent_fund: constituent_fund,
      mpf_trustee: mpf_trustee,
      mpf_trustee_code: mpf_trustee_code,
      fund_type: fund_type,
      launch_date: launch_date_text |> parse_date(),
      current_management_fee_percentage: current_management_fee_percentage,
      latest_fer_percentage: latest_fer_percentage,
      fund_size_in_hkd: fund_size_text |> convert_fund_size_text_to_float(),
      fund_risk_indicator_percentage: fund_risk_indicator_percentage,
      one_year_annualized_return_percentage: one_year_annualized_return_percentage,
      five_years_annualized_return_percentage: five_years_annualized_return_percentage,
      ten_years_annualized_return_percentage: ten_years_annualized_return_percentage,
      annualized_return_percentage: since_launch_annualized_return_percentage
    }
  end

  defp parse_date(
         <<day::bytes-size(2)>> <>
           "-" <> <<month::bytes-size(2)>> <> "-" <> <<year::bytes-size(4)>>
       ) do
    Date.from_iso8601!("#{year}-#{month}-#{day}")
  end

  defp convert_percentage_to_float("n.a."), do: nil

  defp convert_percentage_to_float("Up to " <> percentage),
    do: convert_percentage_to_float(percentage)

  defp convert_percentage_to_float(
         <<_lower_percentage::bytes-size(2)>> <> " - " <> upper_percentage
       ),
       do: convert_percentage_to_float(upper_percentage)

  defp convert_percentage_to_float(
         <<_lower_percentage::bytes-size(3)>> <> " - " <> upper_percentage
       ),
       do: convert_percentage_to_float(upper_percentage)

  defp convert_percentage_to_float(
         <<_lower_percentage::bytes-size(4)>> <> " - " <> upper_percentage
       ),
       do: convert_percentage_to_float(upper_percentage)

  defp convert_percentage_to_float(
         <<_lower_percentage::bytes-size(5)>> <> " - " <> upper_percentage
       ),
       do: convert_percentage_to_float(upper_percentage)

  defp convert_percentage_to_float(
         <<_lower_percentage::bytes-size(6)>> <> " - " <> upper_percentage
       ),
       do: convert_percentage_to_float(upper_percentage)

  defp convert_percentage_to_float(<<percentage::bytes-size(1)>> <> "%"),
    do: convert_percentage_to_float("#{percentage}.0")

  defp convert_percentage_to_float(<<percentage::bytes-size(2)>> <> "%"),
    do: convert_percentage_to_float(percentage)

  defp convert_percentage_to_float(<<percentage::bytes-size(3)>> <> "%"),
    do: convert_percentage_to_float(percentage)

  defp convert_percentage_to_float(<<percentage::bytes-size(4)>> <> "%"),
    do: convert_percentage_to_float(percentage)

  defp convert_percentage_to_float(<<percentage::bytes-size(5)>> <> "%"),
    do: convert_percentage_to_float(percentage)

  defp convert_percentage_to_float(<<percentage::bytes-size(6)>> <> "%"),
    do: convert_percentage_to_float(percentage)

  defp convert_percentage_to_float(percentage) do
    ((percentage |> String.to_float()) / 100) |> Float.round(8)
  end

  defp convert_fund_size_text_to_float("n.a."), do: nil

  defp convert_fund_size_text_to_float(text) when is_binary(text) do
    (text |> String.replace(",", "") |> String.to_float()) * 1_000_000
  end
end
