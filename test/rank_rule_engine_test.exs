
defmodule RankRuleEngineTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.RankRuleEngine

  describe "rank rule engine" do
    test """
    when both pocker hands have different ranks - winner/2 returns winner based
    on partial rank order
    """ do
      rank_one = {"black", :straight_flush, ["2", "3", "4", "5", "6"]}
      rank_two = {"white", :four_of_a_kind, ["2", "K", "K", "K", "K"]}
      assert {:winner, "black", "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test """
    when both pocker hands have rank of :straight_flush - winner/2 returns
    winner based on the highest value
    """ do
      rank_one = {"black", :straight_flush, ["2", "3", "4", "5", "6"]}
      rank_two = {"white", :straight_flush, ["4", "5", "6", "7", "8"]}
      assert {:winner, "white", "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test """
    when both pocker hands have rank of :straight_flush and
    the same highest value -winner/2 returns {:winner, "tie"}
    """ do
      rank_one = {"black", :straight_flush, ["2", "3", "4", "5", "6"]}
      rank_two = {"white", :straight_flush, ["2", "3", "4", "5", "6"]}
      assert {:winner, "tie"} == @subject.winner(rank_one, rank_two)
    end
  end

end
