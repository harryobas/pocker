
defmodule RankRuleEngineTest do
  use ExUnit.Case, async: true

  @subject PockerOpdracht.Ranking.RuleEngine

  describe "rule engine" do
    test """
    when both pocker hands have different ranks - winner/2 returns winner based
    on the partial rank order of pocker hands
    """ do
      rank_one = {"black", :straight_flush, ["2", "3", "4", "5", "6"]}
      rank_two = {"white", :four_of_a_kind, ["2", "K", "K", "K", "K"]}
      assert {:winner, "black", "straight_flush"} == @subject.winner(rank_one, rank_two)
    end
    test """
    when both pocker hands have rank of :straight_flush - winner/2 returns
    winner based on card with the highest value
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
    test """
    when both pocker hands have rank of :four_of_a_kind - winner/2 returns
    winner based on the value of four cards with duplicate values on each
    hand
    """ do
      rank_one = {"black", :four_of_a_kind, ["2", "K", "K", "K", "K"]}
      rank_two = {"white", :four_of_a_kind, ["4", "4", "4", "4", "8"]}
      assert {:winner, "black", "four_of_a_kind"} = @subject.winner(rank_one, rank_two)
    end
  end
  test """
  when both pocker hands have rank :four_of_a_kind and the
  value of four cards of the same value are the same on both
  hands - winner/2 returns {:winner, "tie"}
  """ do
    rank_one = {"black", :four_of_a_kind, ["2", "K", "K", "K", "K"]}
    rank_two = {"white", :four_of_a_kind, ["4", "K", "K", "K", "K"]}
    assert {:winner, "tie"} == @subject.winner(rank_one, rank_two)
  end
  test """
  when both pocker hands have rank of :full_house - winner/2
  returns winner based on value of the three cards which have the
  same value each pocker hand.
  """ do
    rank_one = {"black", :full_house, ["3", "5", "3", "5", "3"]}
    rank_two = {"white", :full_house, ["4", "K", "K", "K", "4"]}
    assert {:winner, "white", "full_house"} == @subject.winner(rank_one, rank_two)
  end
  test """
  when both pocker hands have a rank of :full_house and
  their three cards of the same value are the same - winner/2
  returns {:winner, "tie"}
  """ do
    rank_one = {"black", :full_house, ["3", "K", "K", "K", "3"]}
    rank_two = {"white", :full_house, ["4", "K", "K", "K", "4"]}
    assert {:winner, "tie"} == @subject.winner(rank_one, rank_two)
  end
  test """
  when both pocker hands have a rank of :flush - winner/2 returns winner based
  on the card with highest value
  """ do
    rank_one = {"black", :flush, ["2", "6", "9", "J", "A"]}
    rank_two = {"white", :flush, ["2", "6", "9", "J", "5"]}
    assert {:winner, "black", "flush"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands have a rank of :flush and card with highest
  value is the same on both hands - winner/2 returns {:winner, "tie"}
  """ do
    rank_one = {"black", :flush, ["2", "6", "9", "J", "A"]}
    rank_two = {"white", :flush, ["2", "6", "9", "J", "A"]}
    assert {:winner, "tie"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands have a rank of :straigth - winner/2 returns winner
  based on the card with the highest value
  """ do
    rank_one = {"black", :straight, ["2", "3", "4", "5", "6"]}
    rank_two = {"white", :straight, ["5", "6", "7", "8", "9"]}
    assert {:winner, "white", "straight"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands have a rank of :straight and their
  card with highest value is the same value - winner/2 returns
  {:winner, "tie"}
  """ do
    rank_one = {"black", :straight, ["2", "3", "4", "5", "6"]}
    rank_two = {"white", :straight, ["2", "3", "4", "5", "6"]}
    assert {:winner, "tie"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands have rank :three_of_a_kind - winner/2 returns
  returns winner based on the values of the three cards that are the same
  on both hands
  """ do
    rank_one = {"black", :three_of_a_kind, ["6", "7", "6", "5", "6"]}
    rank_two = {"white", :three_of_a_kind, ["3", "7", "3", "5", "3"]}
    assert {:winner, "black", "three_of_a_kind"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands have rank :three_of_a_kind and
  three cards of the same value are the same on both hands
  """ do
    rank_one = {"black", :three_of_a_kind, ["6", "7", "6", "5", "6"]}
    rank_two = {"white", :three_of_a_kind, ["6", "7", "6", "5", "6"]}
    assert {:winner, "tie"} == @subject.winner rank_one, rank_two

  end
  test """
  when both pocker hands have rank :two_pairs - winner/2 returns
  winner based on the highest pair
  """ do
    rank_one = {"black", :two_pairs, ["K", "5", "K", "5", "7"]}
    rank_two = {"black", :two_pairs, ["2", "4", "2", "4", "7"]}
    assert {:winner, "black", "two_pairs"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands have rank :two_pairs, the
  value of the cards forming the pairs are the same on
  both hands, and the value of the cards not forming a
  pair are the same winner/2 returns {:winner, "tie"}
  """ do
    rank_one = {"black", :two_pairs, ["3", "5", "3", "5", "7"]}
    rank_two = {"white", :two_pairs, ["3", "5", "3", "5", "7"]}
    assert {:winner, "tie"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands have rank :pair - winner/2 returns winner
  based on the value of cards forming the pair on each hand
  """ do
    rank_one = {"black", :pair, ["K", "5", "K", "6", "7"]}
    rank_two = {"white", :pair, ["3", "9", "3", "5", "7"]}
    assert {:winner, "black", "pair"} == @subject.winner rank_one, rank_two
  end
  test """
  when both pocker hands are ranked :pair, value of cards forming pair
  on each hand is the same and the value of the three remaining cards
  are the same on both pocker hands - winner/2 returns {:winner, "tie"}
  """ do
    rank_one = {"black", :pair, ["K", "9", "K", "5", "7"]}
    rank_two = {"white", :pair, ["K", "9", "K", "5", "7"]}
    assert {:winner, "tie"} == @subject.winner rank_one, rank_two

  end


end
