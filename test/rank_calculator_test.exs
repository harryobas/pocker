
defmodule RankCalculatorTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.RankCalculator

  describe "when 5 cards of the same suit with consecutive values" do
    test "compute_rank/1 returns {:ok, hand_name :straight_flush}" do
      hand = [black: "2H 3H 4H 5D 6H"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {:ok, hand_name, :straight_flush} == @subject.compute_rank(hand)
    end
  end
  describe "when 4 cards have the same value" do
    test "compute_rank/1 returns {:ok, hand_name, :four_of_a_kind}" do
      hand = [white: "3C 3H 3S 8C 3H"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {:ok, hand_name, :four_of_a_kind} == @subject.compute_rank(hand)
    end
  end

end
