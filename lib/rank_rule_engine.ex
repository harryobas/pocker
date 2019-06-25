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
        [h|t] = dupes
        case 3 == Enum.count(values, fn v -> v == h end) do
          true -> {:ok, h}
          false -> {:ok, hd(t)}
        end
        false -> {:ok, hd(dupes)}
    end
  end

  def get_values_rank(player_one, player_two) do
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
