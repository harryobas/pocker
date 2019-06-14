
defmodule RankCalculatorTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.RankCalculator

  describe "rank computation" do
    test "5 cards of same suit with consecutive values - compute_rank/1 returns {:ok, hand_name :straight_flush}" do
      hand = [black: "2H 3H 4H 5H 6H"]
      values = ["2", "3", "4", "5", "6"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :straight_flush, values} == @subject.compute_rank(hand)
    end
    test "4 cards with the same value - compute_rank/1 returns {:ok, hand_name, :four_of_a_kind}" do
      hand = [white: "3H 5D 5S 5C 5H"]
      values = ["3", "5", "5", "5", "5"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :four_of_a_kind, values} == @subject.compute_rank(hand)
    end
  end

end
