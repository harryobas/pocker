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

        {:ok, dupe_val_one} = get_dupe_value_full_house(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = get_dupe_value_full_house(player_two_values, dupe_two_values)

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

        {:ok, dupe_val_one} = get_dupe_value_full_house(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = get_dupe_value_full_house(player_two_values, dupe_two_values)

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

        {:ok, dupe_val_one} = get_dupe_value_full_house(player_one_values, dupe_one_values)
        {:ok, dupe_val_two} = get_dupe_value_full_house(player_two_values, dupe_two_values)

          values_map()[dupe_val_two] == values_map()[dupe_val_one]
    end

  end

  defp get_dupe_value_full_house(values, dupes) do
    case length(dupes) == 2 do
      true ->
        [h|t] = dupes
        case 3 == Enum.count(values, fn v -> v == h end) do
          true -> {:ok, h}
          false -> {:ok, hd(t)}
        end
        _ -> :error
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
