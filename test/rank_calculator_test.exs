
defmodule RankCalculatorTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.RankCalculator

  describe "rank computation" do
    test "5 cards of same suit with consecutive values - compute_rank/1 returns {:ok, hand_name :straight_flush}" do
      hand = [black: "2H 3H 4H 5H 6H"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {:ok, hand_name, :straight_flush} == @subject.compute_rank(hand)
    end
  end

end
