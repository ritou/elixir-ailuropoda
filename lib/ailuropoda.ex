defmodule Ailuropoda do
  @moduledoc """
  Ailuropoda is Chinese Personal ID Card Validator for Elixir.
  """

  require Logger

  # ID format
  @cert_pattern ~r/\A(?<address>[0-9]{6})(?<birthdate>[0-9]{8})[0-9]{3}[0-9X]{1}\z/

  @doc """
  TODO
  """

  @spec is_valid?(String.t) :: boolean
  def is_valid?(cert) do
    case Regex.named_captures(@cert_pattern, cert) do
      nil -> false
      %{"address" => address, "birthdate" => birthdate} ->
        if is_valid_address?(address) &&
           is_valid_birthdate?(birthdate) &&
           is_valid_checkdigit?(cert) do
          true
        else
          false
        end
    end
  end

  defp is_valid_address?(address) do
    gb2260 = GB2260.get(address)
    !is_nil(gb2260.name)
  end

  @birthdate_pattern ~r/\A(?<year>[0-9]{4})(?<month>[0-9]{2})(?<day>[0-9]{2})\z/
  defp is_valid_birthdate?(birthdate) do
    with %{"year" => year, "month" => month, "day" => day} <- Regex.named_captures(@birthdate_pattern, birthdate),
         {:ok, _} <- Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day)) do
      true
    else
      _ -> false
    end
  end

  @weights [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1]
  defp is_valid_checkdigit?(cert) do
    cert_list = String.codepoints(cert) |> List.delete_at(-1)
    check_digit = String.at(cert, -1)

    body_sum = Enum.reduce(0..17,
                           fn(i, sum) ->
                             String.to_integer(Enum.at(cert_list, i - 1)) * Enum.at(@weights, i - 1) + sum
                           end)

    case 12 - rem(body_sum,11) do
      10 ->
        check_digit == "X"
      cd when cd > 10 ->
        check_digit == Integer.to_string(rem(cd,11))
      cd ->
        check_digit == Integer.to_string(cd)
    end
  end
end
