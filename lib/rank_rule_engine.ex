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

  def winner(player_one, player_two) do
    cond do
      @pocker_hands[elem(player_one, 1)] > @pocker_hands[elem(player_two, 1)] ->
        {:winner, elem(player_one, 0), to_string(elem(player_one, 1))}

      @pocker_hands[elem(player_two, 1)] > @pocker_hands[elem(player_one, 1)] ->
        {:winner, elem(player_two, 0), to_string(elem(player_two, 1))}

      @pocker_hands[elem(player_one, 1)] == @pocker_hands[elem(player_two, 1)] ->
        apply_same_rank_rule

    end

  end

end
