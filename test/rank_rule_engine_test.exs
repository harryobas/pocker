defmodule RankRuleEngineTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.RankRuleEngine

  describe "rank rule engine" do
    test "when straight_flush and four_of_a_kind - winner/2 returns {:winner, straight_flush}" do
      rank_one = :straight_flush
      rank_two = :four_of_a_kind
      assert {:winner, "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test "when straight_flush and full_house - winner/2 returns {:winner, straight_flush}" do
      rank_one = :straight_flush
      rank_two = :full_house
      assert {:winner, "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test "when straight_flush and flush - winner/2 returns {:winner, straight_flush}" do
      rank_one = :straight_flush
      rank_two = :flush
      assert {:winner, "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test "when straight_flush and straight - winner/2 returns {:winner, straight_flush}" do
      rank_one = :straight_flush
      rank_two = :straight
      assert {:winner, "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test "when straight_flush and three_of_a_kind - winner/2 returns {:winner, straight_flush}" do
      rank_one = :straight_flush
      rank_two = :three_of_a_kind
      assert {:winner, "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test "when straight flush and two_pairs - winner/2 returns {:winner, straight_flush}" do
      rank_one = :straight_flush
      rank_two = :two_pairs
      assert {:winner, "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test "when straight_flush and pair - winner/2 returns {:winner, :straight_flush}" do
      rank_one = :straight_flush
      rank_two = :pair
      assert {:winner, "straight_flush"} == @subject.winner(rank_one, rank_two)

    end

  end

end
