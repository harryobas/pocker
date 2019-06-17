defmodule PockerOpdracht.RankRuleEngine do
  @moduledoc """
  provides functions to ascertain the winner between
  two ranked pocker hands
  """
  @pocker_hands %{
    :high_card => 0,
    :pair => 1,
    :two_pairs => 2,
    :three_of_a_kind => 3,
    :straight => 4,
    :flush => 5,
    :full_house => 6,
    :four_of_a_kind => 7,
    :straight_flush => 8
  }

  def winner(rank_one, rank_two) do
    cond do
      @pocker_hands[rank_one] > @pocker_hands[rank_two] ->
        {:winner, to_string(rank_one)}
    end
  end

end
