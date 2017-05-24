defmodule AiluropodaTest do
  use ExUnit.Case
  doctest Ailuropoda

  test "is_valid?" do
    # invalid address
    assert !Ailuropoda.is_valid?("000000000000000000")

    # invalid birthdate
    assert !Ailuropoda.is_valid?("110000000000000000")

    # invalid checkdigit
    assert !Ailuropoda.is_valid?("110000200001010001")

    # valid ID
    # https://github.com/mc-zone/IDValidator/blob/master/tests/spec/specTest.js
    assert Ailuropoda.is_valid?("371001198010082394")

    # https://zh.wikisource.org/wiki/GB_11643-1999_%E5%85%AC%E6%B0%91%E8%BA%AB%E4%BB%BD%E5%8F%B7%E7%A0%81
    assert Ailuropoda.is_valid?("11010519491231002X")

    # 15digit
    assert Ailuropoda.is_valid?("371001801008239")
  end
end
