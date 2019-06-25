
defmodule RankCalculatorTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.Ranking.Oracle

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
    test "5 cards of the same suit - compute_rank/1 returns {hand_name, :flush, values}" do
        hand = [black: "2H 6H 9H JH AH"]
        values = ["2", "6", "9", "J", "A"]
        hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
        assert {hand_name, :flush, values} == @subject.compute_rank(hand)
    end
    test "5 cards with consecutive values - compute_rank/1 returns {hand_name, :straight, values}" do
      hand = [black: "2D 3C 4H 5S 6H"]
      values = ["2", "3", "4", "5", "6"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :straight, values} == @subject.compute_rank(hand)
    end
    test "3 cards have the same value - compute_rank/1 returns {hand_name, :three_of_a_kind, values}" do
      hand = [black: "3H 7S 3C 5H 3D"]
      values = ["3", "7", "3", "5", "3"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :three_of_a_kind, values} == @subject.compute_rank(hand)
    end
    test "hand contains 2 different pairs - compute_rank/1 returns {hand_name, :two_pairs, values}" do
      hand = [black:  "3H 5S 3C 5H 7D"]
      values = ["3", "5", "3", "5", "7"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :two_pairs, values} == @subject.compute_rank(hand)
    end
    test "hand contains a pair - compute_rank/1 returns {hand_name, :pair, values}" do
      hand = [black: "3H 5S 3C 7D 4C"]
      values = ["3", "5", "3", "7", "4"]
      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :pair, values} == @subject.compute_rank(hand)
    end
    test """
    hand is niether one of straight_flush, four_of_a_kind, full_house, flush,
    straight, three_of_a_kind, two_pairs and pair - compute_rank/1
    rethrns {hand_name, :high_card, values}
    """ do
      hand = [black: "2H 3D 5S 9C KD"]
      values = ["2", "3", "5", "9", "K"]

      hand_name = hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
      assert {hand_name, :high_card, values} == @subject.compute_rank(hand)

    end
  end

end
