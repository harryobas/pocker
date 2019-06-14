
defmodule RankCalculatorTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.RankCalculator

  describe "rank computation" do
    test "5 cards of same suit with consecutive values - compute_rank/1 returns {hand_name, :straight_flush, values}" do
      hand = [black: "2H 3H 4H 5H 6H"]
      values = ["2", "3", "4", "5", "6"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :straight_flush, values} == @subject.compute_rank(hand)
    end
    test "4 cards have the same value - compute_rank/1 returns {hand_name, :four_of_a_kind, values}" do
      hand = [white: "2H KD KH KS KC"]
      values = ["2", "K", "K", "K", "K"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :four_of_a_kind, values} == @subject.compute_rank(hand)
    end
    test "3 cards have the same value with remaining two forming a pair - compute_rank/1 returns {hand_name, :full_house, values}" do

      hand = [black: "3H 5S 3C 5H 3D"]
      values = ["3", "5", "3", "5", "3"]

      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :full_house, values} == @subject.compute_rank(hand)
    end
  end

end
