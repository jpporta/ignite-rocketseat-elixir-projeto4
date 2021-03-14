defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(
      %{all_hours: %{}, hours_per_month: %{}, hours_per_year: %{}},
      fn record, report ->
        sum_values(record, report)
      end
    )
  end

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.map(& &1)
    |> Enum.reduce(%{all_hours: %{}, hours_per_month: %{}, hours_per_year: %{}}, fn {:ok, result},
                                                                                    report ->
      sum_reports(report, result)
    end)
  end

  defp sum_reports(
         %{
           :all_hours => all_hours1,
           :hours_per_month => hours_per_month1,
           :hours_per_year => hours_per_year1
         },
         %{
           :all_hours => all_hours2,
           :hours_per_month => hours_per_month2,
           :hours_per_year => hours_per_year2
         }
       ) do
    all_hours = merge_map(all_hours1, all_hours2)
    hours_per_month = merge_map_employee(hours_per_month1, hours_per_month2)
    hours_per_year = merge_map_employee(hours_per_year1, hours_per_year2)
    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      :all_hours => all_hours,
      :hours_per_month => hours_per_month,
      :hours_per_year => hours_per_year
    }
  end

  defp merge_map_employee(map1, map2) do
    Map.merge(map1, map2, fn _k, e1, e2 ->
      Map.merge(e1, e2, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  defp merge_map(map1, map2) do
    Map.merge(map1, map2, fn _k, v1, v2 -> v1 + v2 end)
  end

  defp sum_values(
         [name, hours, _day, month, year],
         %{
           :all_hours => all_hours,
           :hours_per_month => hours_per_month,
           :hours_per_year => hours_per_year
         }
       ) do
    all_hours = all_hours_update(all_hours, name, hours)
    hours_per_month = hours_per_month_update(hours_per_month, name, month, hours)
    hours_per_year = hours_per_year_update(hours_per_year, name, year, hours)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp all_hours_update(all_hours, name, hours) do
    all_hours_acc = Map.get(all_hours, name, 0)
    Map.put(all_hours, name, all_hours_acc + hours)
  end

  defp hours_per_month_update(acc, name, month, hours) do
    employee = Map.get(acc, name, %{})
    month_name = Enum.at(@months, month - 1)
    month_acc = Map.get(employee, month_name, 0)
    updated_employee = Map.put(employee, month_name, month_acc + hours)
    Map.put(acc, name, updated_employee)
  end

  defp hours_per_year_update(acc, name, year, hours) do
    employee = Map.get(acc, name, %{})
    year_acc = Map.get(employee, year, 0)
    updated_employee = Map.put(employee, year, year_acc + hours)
    Map.put(acc, name, updated_employee)
  end

  # defp empty_acc_months(), do: Enum.reduce(@months, fn m -> %{"#{m}": 0} end)
end
