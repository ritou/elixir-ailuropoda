defmodule Ailuropoda do
  @moduledoc """
  Ailuropoda is Chinese Personal ID Card Validator for Elixir.

  ```
  id_card_number = "371001198010082394"
  
  if Ailuropoda.is_valid?(id_card_number) do
    # ,,,
  else
    # ...
  end
  ```
  """

  require Logger

  # ID format
  @cert_pattern_18digit ~r/\A(?<address>[0-9]{6})(?<birthdate>[0-9]{8})[0-9]{3}[0-9X]{1}\z/
  @cert_pattern_15digit ~r/\A(?<address>[0-9]{6})(?<birthdate>[0-9]{6})[0-9]{3}\z/

  @doc """
  If ID card number is valid, this function returns true.

  spec : https://zh.wikisource.org/wiki/GB_11643-1999_%E5%85%AC%E6%B0%91%E8%BA%AB%E4%BB%BD%E5%8F%B7%E7%A0%81
  """

  @spec is_valid?(String.t) :: boolean
  def is_valid?(cert) do
    case Regex.named_captures(@cert_pattern_18digit, cert) do
      %{"address" => address, "birthdate" => birthdate} ->
        is_valid_address?(address) && is_valid_birthdate?(birthdate) && is_valid_checkdigit?(cert)
      nil ->
        case Regex.named_captures(@cert_pattern_15digit, cert) do
          %{"address" => address, "birthdate" => birthdate} ->
            is_valid_address?(address) && is_valid_birthdate?("19#{birthdate}")
          nil -> false
        end
    end
  end

  defp is_valid_address?(address) do
    !is_nil(GB2260.get(address).name)
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

    body_sum = Enum.reduce(0..17,
                           fn(i, sum) ->
                             String.to_integer(Enum.at(cert_list, i - 1)) * Enum.at(@weights, i - 1) + sum
                           end)

    check_digit = String.at(cert, -1)
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
