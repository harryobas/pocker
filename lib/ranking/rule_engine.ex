defmodule PockerOpdracht.Ranking.RuleEngine do

  import PockerOpdracht.Ranking.Oracle


  @moduledoc """
  provides functions and rules to ascertain the winner between
  pairs of ranked pocker hands
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

      @pocker_hands[elem(player_one, 1)] == @pocker_hands[elem(player_two, 1)] ->
        same_rank_rules(player_one, player_two)

      end
    end

   defp same_rank_rules(player_one, player_two) do
     cond do
       player_one_wins_with_straight_flush?(player_one, player_two) ->
         {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

       player_two_wins_with_straight_flush?(player_one, player_two) ->
         {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

       player_one_and_player_two_tie_on_straight_flush?(player_one, player_two) ->
         {:ok, :tie}

       player_one_and_player_two_tie_on_four_of_a_kind?(player_one, player_two) ->
         {:ok, :tie}

       player_one_wins_with_four_of_a_kind?(player_one, player_two) ->
         {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

       player_two_wins_with_four_of_a_kind?(player_one, player_two) ->
         {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

       player_one_wins_with_full_house?(player_one, player_two) ->
         {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

       player_two_wins_with_full_house?(player_one, player_two) ->
         {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

       player_one_and_player_two_tie_on_full_house?(player_one, player_two) ->
         {:ok, :tie}

      player_one_wins_with_flush?(player_one, player_two) ->
        {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

      player_two_wins_with_flush?(player_one, player_two) ->
        {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

      player_one_and_player_two_tie_on_flush?(player_one, player_two) ->
        {:ok, :tie}

      player_one_wins_with_straight?(player_one, player_two) ->
         {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

      player_two_wins_with_straight?(player_one, player_two) ->
        {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

      player_one_and_player_two_tie_on_straight?(player_one, player_two) ->
        {:ok, :tie}

      player_one_wins_with_three_of_a_kind?(player_one, player_two) ->
        {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

      player_two_wins_with_three_of_a_kind?(player_one, player_two) ->
        {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

      player_one_and_player_two_tie_on_three_of_a_kind?(player_one, player_two) ->
        {:ok, :tie}

      player_one_wins_with_two_pairs?(player_one, player_two) ->
        {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

      player_two_wins_with_two_pairs?(player_one, player_two) ->
        {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

      player_one_and_player_two_tie_on_two_pairs?(player_one, player_two) ->
        {:ok, :tie}

      player_one_wins_with_pair?(player_one, player_two) ->
        {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

      player_two_wins_with_pair?(player_one, player_two) ->
        {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

      player_one_and_player_two_tie_on_pair?(player_one, player_two) ->
        {:ok, :tie}

      player_one_wins_with_high_card?(player_one, player_two) ->
        {:ok, elem(player_one, 0), to_string(elem(player_one, 1))}

      player_two_wins_with_high_card?(player_one, player_two) ->
        {:ok, elem(player_two, 0), to_string(elem(player_two, 1))}

      player_one_and_player_two_tie_on_high_card?(player_one, player_two) ->
        {:ok, :tie}

     end

   end

  defp player_one_wins_with_straight_flush?(player_one, player_two) do

    {player_one_rank , player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :straight_flush && player_two_rank == :straight_flush do
      false -> false
      true ->
        {player_one_values, player_two_values} = get_values_rank(player_one, player_two)
        (Enum.max player_one_values) > (Enum.max player_two_values)
    end
  end

  defp player_two_wins_with_straight_flush?(player_one, player_two) do
    {player_one_rank , player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :straight_flush && player_two_rank == :straight_flush do
      false ->false
      true ->
        {player_one_values, player_two_values} = get_values_rank(player_one, player_two)
        (Enum.max player_two_values) > (Enum.max player_one_values)
    end
  end

  defp player_one_and_player_two_tie_on_straight_flush?(player_one, player_two) do

    {player_one_rank , player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :straight_flush && player_two_rank == :straight_flush do
      false ->false
      true ->
        {player_one_values, player_two_values} = get_values_rank(player_one, player_two)
        (Enum.max player_two_values) == (Enum.max player_one_values)
    end
  end

  defp player_one_wins_with_four_of_a_kind?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :four_of_a_kind && player_two_rank == :four_of_a_kind do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)
        values_map()[hd(dupe_one_values)] > values_map()[hd(dupe_two_values)]
    end
  end

  defp player_two_wins_with_four_of_a_kind?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :four_of_a_kind && player_two_rank == :four_of_a_kind do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)
        values_map()[hd(dupe_two_values)] > values_map()[hd(dupe_one_values)]
    end

  end

  defp player_one_and_player_two_tie_on_four_of_a_kind?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :four_of_a_kind && player_two_rank == :four_of_a_kind do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)
        values_map()[hd(dupe_two_values)] == values_map()[hd(dupe_one_values)]
    end

  end

  defp player_one_wins_with_full_house?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :full_house && player_two_rank == :full_house do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {:ok, dupe_val_one} = three_dupe_values(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = three_dupe_values(player_two_values, dupe_two_values)

          values_map()[dupe_val_one] > values_map()[dupe_val_two]
    end

  end

  defp player_two_wins_with_full_house?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :full_house && player_two_rank == :full_house do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {:ok, dupe_val_one} = three_dupe_values(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = three_dupe_values(player_two_values, dupe_two_values)

          values_map()[dupe_val_two] > values_map()[dupe_val_one]
    end

  end

  defp player_one_and_player_two_tie_on_full_house?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :full_house && player_two_rank == :full_house do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {:ok, dupe_val_one} = three_dupe_values(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = three_dupe_values(player_two_values, dupe_two_values)

          values_map()[dupe_val_two] == values_map()[dupe_val_one]
    end

  end

  defp player_one_wins_with_flush?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :flush && player_two_rank == :flush do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {val_one, val_two} = high_card_rule(player_one_values, player_two_values)
        val_one > val_two
    end

  end

  defp player_two_wins_with_flush?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :flush && player_two_rank == :flush do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {val_one, val_two} = high_card_rule(player_one_values, player_two_values)
        val_two > val_one
    end

  end

  defp player_one_and_player_two_tie_on_flush?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :flush && player_two_rank == :flush do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {val_one, val_two} = high_card_rule(player_one_values, player_two_values)
        val_two == val_one
    end

  end

  def player_one_wins_with_straight?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :straight && player_two_rank == :straight do
      false -> false
      true ->
        {player_one_values, player_two_values} = get_values_rank(player_one, player_two)
        (Enum.max player_one_values) > (Enum.max player_two_values)
    end
  end

  def player_two_wins_with_straight?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :straight && player_two_rank == :straight do
      false -> false
      true ->
        {player_one_values, player_two_values} = get_values_rank(player_one, player_two)
        (Enum.max player_two_values) > (Enum.max player_one_values)
    end

  end

  defp player_one_and_player_two_tie_on_straight?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :straight && player_two_rank == :straight do
      false -> false
      true ->
        {player_one_values, player_two_values} = get_values_rank(player_one, player_two)
        (Enum.max player_two_values) == (Enum.max player_one_values)
    end

  end

  def player_one_wins_with_three_of_a_kind?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :three_of_a_kind && player_two_rank == :three_of_a_kind do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {:ok, dupe_val_one} = three_dupe_values(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = three_dupe_values(player_two_values, dupe_two_values)

          values_map()[dupe_val_one] > values_map()[dupe_val_two]
    end

  end

  defp player_two_wins_with_three_of_a_kind?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :three_of_a_kind && player_two_rank == :three_of_a_kind do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {:ok, dupe_val_one} = three_dupe_values(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = three_dupe_values(player_two_values, dupe_two_values)

          values_map()[dupe_val_two] > values_map()[dupe_val_one]
    end

  end

  defp player_one_and_player_two_tie_on_three_of_a_kind?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :three_of_a_kind && player_two_rank == :three_of_a_kind do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {:ok, dupe_val_one} = three_dupe_values(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = three_dupe_values(player_two_values, dupe_two_values)

          values_map()[dupe_val_two] == values_map()[dupe_val_one]
    end

  end

  defp player_one_wins_with_two_pairs?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :two_pairs && player_two_rank == :two_pairs do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {uniq_one, uniq_two} = uniq_values_two_pairs(player_one_values, player_two_values)

        pair_one_and_uniq = {hd(dupe_one_values), hd(tl(dupe_one_values)), uniq_one}
        pair_two_and_uniq = {hd(dupe_two_values), hd(tl(dupe_two_values)), uniq_two}

        {val_one, val_two} = two_pairs_rule(pair_one_and_uniq, pair_two_and_uniq)

        val_one > val_two

    end

  end

  defp player_two_wins_with_two_pairs?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :two_pairs && player_two_rank == :two_pairs do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {uniq_one, uniq_two} = uniq_values_two_pairs(player_one_values, player_two_values)

        pair_one_and_uniq = {hd(dupe_one_values), hd(tl(dupe_one_values)), uniq_one}
        pair_two_and_uniq = {hd(dupe_two_values), hd(tl(dupe_two_values)), uniq_two}

        {val_one, val_two} = two_pairs_rule(pair_one_and_uniq, pair_two_and_uniq)

        val_two > val_one
      end

  end

  defp player_one_and_player_two_tie_on_two_pairs?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :two_pairs && player_two_rank == :two_pairs do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {uniq_one, uniq_two} = uniq_values_two_pairs(player_one_values, player_two_values)

        two_pairs_one_and_uniq = {hd(dupe_one_values), hd(tl(dupe_one_values)), uniq_one}
        two_pairs_two_and_uniq = {hd(dupe_two_values), hd(tl(dupe_two_values)), uniq_two}

        {val_one, val_two} = two_pairs_rule(two_pairs_one_and_uniq, two_pairs_two_and_uniq)

        val_two == val_one
      end

  end

  defp player_one_wins_with_pair?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :pair && player_two_rank == :pair do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {uniq_one, uniq_two} = uniq_values_pair(player_one_values, player_two_values)

        pair_one_and_uniq = {hd(dupe_one_values), uniq_one}
        pair_two_and_uniq = {hd(dupe_two_values), uniq_two}

        {val_one, val_two} = pair_rule(pair_one_and_uniq, pair_two_and_uniq)

        val_one > val_two

    end

  end

  defp player_two_wins_with_pair?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :pair && player_two_rank == :pair do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {uniq_one, uniq_two} = uniq_values_pair(player_one_values, player_two_values)

        pair_one_and_uniq = {hd(dupe_one_values), uniq_one}
        pair_two_and_uniq = {hd(dupe_two_values), uniq_two}

        {val_one, val_two} = pair_rule(pair_one_and_uniq, pair_two_and_uniq)

        val_two > val_one

    end

  end

  defp player_one_and_player_two_tie_on_pair?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :pair && player_two_rank == :pair do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {dupe_one_values, dupe_two_values} = dupe_values(player_one_values, player_two_values)

        {uniq_one, uniq_two} = uniq_values_pair(player_one_values, player_two_values)

        pair_one_and_uniq = {hd(dupe_one_values), uniq_one}
        pair_two_and_uniq = {hd(dupe_two_values), uniq_two}

        {val_one, val_two} = pair_rule(pair_one_and_uniq, pair_two_and_uniq)

        val_two == val_one

    end

  end

  defp player_one_wins_with_high_card?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :high_card && player_two_rank == :high_card do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {val_one, val_two} = high_card_rule(player_one_values, player_two_values)

        val_one > val_two
    end

  end

  defp player_two_wins_with_high_card?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :high_card && player_two_rank == :high_card do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {val_one, val_two} = high_card_rule(player_one_values, player_two_values)

        val_two > val_one
    end

  end

  defp player_one_and_player_two_tie_on_high_card?(player_one, player_two) do
    {player_one_rank, player_two_rank} = get_players_rank(player_one, player_two)

    case player_one_rank == :high_card && player_two_rank == :high_card do
      false -> false
      true ->
        player_one_values = elem(player_one, 2)
        player_two_values = elem(player_two, 2)

        {val_one, val_two} = high_card_rule(player_one_values, player_two_values)

        val_one == val_two
    end

  end


  defp pair_rule(values_one, values_two) do
    uniq_one = elem(values_one, 1)
    |> Enum.map(fn v -> values_map()[v]end)
    |> Enum.sort()
    |> Enum.reverse()

    uniq_two = elem(values_two, 1)
    |> Enum.map(fn v -> values_map()[v]end)
    |> Enum.sort()
    |> Enum.reverse()

    pair_one = elem(values_one, 0)
    pair_two = elem(values_two, 0)

    case pair_one == pair_two do
      false -> {pair_one, pair_two}
      true ->
        case Enum.at(uniq_one, 0) == Enum.at(uniq_two, 0) do
          false -> {Enum.at(uniq_one, 0), Enum.at(uniq_two, 0)}
          true ->
            case Enum.at(uniq_one, 1) == Enum.at(uniq_two, 1) do
              false -> {Enum.at(uniq_one, 1), Enum.at(uniq_two, 1)}
              true ->
                case Enum.at(uniq_one, 2) == Enum.at(uniq_two, 2) do
                  false -> {Enum.at(uniq_one, 2), Enum.at(uniq_two, 2)}
                  true -> {Enum.at(uniq_one, 2), Enum.at(uniq_two, 2)}
                end
            end

        end
    end

  end

  defp two_pairs_rule(values_one, values_two) do
    first_pair_one = values_map()[elem(values_one, 0)]
    second_pair_one = values_map()[elem(values_one, 1)]
    uniq_one = values_map()[elem(values_one, 2)]

    first_pair_two = values_map()[elem(values_two, 0)]
    second_pair_two = values_map()[elem(values_two, 1)]
    uniq_two = values_map()[elem(values_two, 2)]

    case first_pair_one > second_pair_one && first_pair_two > second_pair_two do
      true ->
        {first_pair_one, first_pair_two}
      false ->
        case second_pair_one > first_pair_one && second_pair_two > first_pair_two do
          true ->
            {second_pair_one, second_pair_two}
          false ->
            {uniq_one, uniq_two}
        end
      end
    end



  defp uniq_values_two_pairs(values_one, values_two) do
    uniq_one = Enum.uniq(values_one)
    uniq_two = Enum.uniq(values_two)

    {hd(uniq_one), hd(uniq_two)}

  end

  defp uniq_values_pair(values_one, values_two) do
    values_one = Enum.uniq(values_one)
    values_two = Enum.uniq(values_two)

    {values_one, values_two}

  end


  defp high_card_rule(values_one, values_two) do
    values_one = values_one
    |> Enum.map(fn v -> values_map()[v]end)
    |> Enum.sort()
    |> Enum.reverse()

    values_two = values_two
    |> Enum.map(fn v -> values_map()[v]end)
    |> Enum.sort()
    |> Enum.reverse()

    case Enum.at(values_one, 0) == Enum.at(values_two, 0) do
      false -> {Enum.at(values_one, 0), Enum.at(values_two, 0)}
      true ->
        case Enum.at(values_one, 1) == Enum.at(values_two, 1) do
          false -> {Enum.at(values_one, 1), Enum.at(values_two, 1)}
          true ->
            case Enum.at(values_one, 2) == Enum.at(values_two, 2) do
              false -> {Enum.at(values_one, 2), Enum.at(values_two, 2)}
              true ->
                case Enum.at(values_one, 3) == Enum.at(values_two, 3) do
                  false -> {Enum.at(values_one, 3), Enum.at(values_two, 3)}
                  true ->
                    case Enum.at(values_one, 4) == Enum.at(values_two, 4) do
                      false -> {Enum.at(values_one, 4), Enum.at(values_two, 4)}
                      true ->
                        {Enum.at(values_one, 4), Enum.at(values_two, 4)}
                    end
                end

            end
        end

    end

  end

  defp three_dupe_values(values, dupes) do
    case length(dupes) == 2 do
      true ->
        cond do
          3 == Enum.count(values, fn v -> v == Enum.at(dupes, 0) end) ->
            {:ok, Enum.at(dupes, 0)}
          3 == Enum.count(values, fn v -> v == Enum.at(dupes, 1)end) ->
            {:ok, Enum.at(dupes, 1)}
          end
      false ->
        {:ok, hd(dupes)}
    end

  end

  defp get_values_rank(player_one, player_two) do
    player_one_values = elem(player_one, 2)
    player_two_values = elem(player_two, 2)

    player_one_values = player_one_values |> Enum.map(fn v -> values_map()[v]end)
    player_two_values = player_two_values |> Enum.map(fn v -> values_map()[v]end)

    {player_one_values, player_two_values}

  end

  defp get_players_rank(player_one, player_two) do
    player_one_rank = elem(player_one, 1)
    player_two_rank = elem(player_two, 1)

    {player_one_rank, player_two_rank}

  end

  defp dupe_values(values_one, values_two) do
    dupe_one_values = duplicate(values_one)
    dupe_two_values = duplicate(values_two)

    {dupe_one_values, dupe_two_values}
  end

  defp duplicate(list) do
    acc_dupes = fn x, {elems, dupes} ->
      case Map.has_key?(elems, x) do
        true -> {elems, Map.put(dupes, x, nil)}
        false -> {Map.put(elems, x, nil), dupes}
      end
  end
    list |> Enum.reduce({%{}, %{}}, acc_dupes) |> elem(1) |> Map.keys()
  end

end
