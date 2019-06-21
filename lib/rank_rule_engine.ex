defmodule PockerOpdracht.RankRuleEngine do

  import PockerOpdracht.RankCalculator


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
    case get_winner(player_one, player_two) do
      {:ok, player, rank} -> {:winner, player, rank}
      {:ok, :tie} -> {:winner, "tie"}
    end
  end

    defp get_winner(player_one, player_two) do
      cond do
        @pocker_hands[elem(player_one, 1)] > @pocker_hands[elem(player_two, 1)] ->
          {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

        @pocker_hands[elem(player_two, 1)] > @pocker_hands[elem(player_one, 1)] ->
          {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

        player_one_wins_with_straight_flush?(player_one, player_two) ->
          {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

        player_two_wins_with_straight_flush?(player_one, player_two) ->
          {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

        player_one_and_player_two_tie_on_straight_flush?(player_one, player_two) ->
          {:ok, :tie}
        end
      end

    defp player_one_wins_with_straight_flush?(player_one, player_two) do
      player_one_values = elem(player_one, 2)
      player_two_values = elem(player_two, 2)

      player_one_values = player_one_values |> Enum.map(fn v -> values_map()[v]end)
      player_two_values = player_two_values |> Enum.map(fn v -> values_map()[v]end)

      player_one_rank = elem(player_one, 1)
      player_two_rank = elem(player_two, 1)

      case player_one_rank == :straight_flush && player_two_rank == :straight_flush do
        false ->false
        true ->
          (Enum.max player_one_values) > (Enum.max player_two_values)
      end
    end

    defp player_two_wins_with_straight_flush?(player_one, player_two) do
      player_one_values = elem(player_one, 2)
      player_two_values = elem(player_two, 2)

      player_one_values = player_one_values |> Enum.map(fn v -> values_map()[v]end)
      player_two_values = player_two_values |> Enum.map(fn v -> values_map()[v]end)

      player_one_rank = elem(player_one, 1)
      player_two_rank = elem(player_two, 1)

      case player_one_rank == :straight_flush && player_two_rank == :straight_flush do
        false ->false
        true ->
          (Enum.max player_two_values) > (Enum.max player_one_values)
      end

    end

    defp player_one_and_player_two_tie_on_straight_flush?(player_one, player_two) do
      player_one_values = elem(player_one, 2)
      player_two_values = elem(player_two, 2)

      player_one_values = player_one_values |> Enum.map(fn v -> values_map()[v]end)
      player_two_values = player_two_values |> Enum.map(fn v -> values_map()[v]end)

      player_one_rank = elem(player_one, 1)
      player_two_rank = elem(player_two, 1)

      case player_one_rank == :straight_flush && player_two_rank == :straight_flush do
        false ->false
        true ->
          (Enum.max player_two_values) == (Enum.max player_one_values)
      end
    end

  end
