defmodule PockerOpdracht.RankCalculator do

  @moduledoc """
  provides functions cumputing the rank of a pocker hand
  """

  @index [0, 1, 2, 3, 4]
  @values_rank %{
    "2" => 0,
    "3" => 1,
    "4" => 2,
    "5" => 3,
    "6" => 4,
    "7" => 5,
    "8" => 6,
    "9" => 7,
    "T" => 8,
    "J" => 9,
    "Q" => 10,
    "K" => 11,
    "A" => 12
  }

  def compute_rank(pocker_hand) do
    hand_name =
      pocker_hand
      |> Enum.into(%{})
      |> Map.keys
      |> List.first
      |> to_string

    poker_hand = hd(pocker_hand)
    {_, deck} = poker_hand
    suits = deck |> String.split(" ") |> extract_suites
    values = deck |> String.split(" ") |> extract_values

    case get_rank(suits, values) do
      {:ok, rank} ->
        cond do
          rank == :straight_flush -> {hand_name, :straight_flush, values}
          rank == :four_of_a_kind -> {hand_name, :four_of_a_kind, values}
          rank == :full_house -> {hand_name, :full_house, values}

          true ->
            {hand_name, :high_card, values}
        end
    end

  end

  defp get_rank(suits, values) do
    cond do
      is_straight_flush?(suits, values) -> {:ok, :straight_flush}
      is_four_of_a_kind?(values) -> {:ok, :four_of_a_kind}
      is_full_house?(values) -> {:ok, :full_house}

    end

  end

  defp extract_suites(suits) do
    Enum.map suits, fn s ->
      s |> String.split("") |> Enum.at(2)
    end
  end

  defp extract_values(values) do
    Enum.map values, fn v ->
      v |> String.split("") |> Enum.at(1)
    end
  end

  defp is_straight_flush?(suits, values) when is_list(suits) do
    case same_suits?(suits) && has_consecutive_values?(values) do
      true -> true
      false -> false
    end
  end

  def same_suits?(suits) do
    case Enum.count(suits) == 5 do
      true -> Enum.all?(suits, fn s -> suits -- List.duplicate(s, 5) == [] end)
      false -> false
    end
  end

  defp has_consecutive_values?(values) do
    case Enum.count(values) == 5 do
      false -> false
      true ->
        values = Enum.map values, fn x -> @values_rank[x] end
        Enum.all? values, fn v ->
          Enum.each @index, fn i ->
            v + 1 == Enum.at(values, i + 1)
          end
        end
      end
  end

  defp is_four_of_a_kind?(values) do
    case Enum.count(values) == 5 do
      false -> false
      true ->
        Enum.any? values, fn v ->
          4 == Enum.count values, fn s -> s == v
        end
      end 
      end
    end

    defp is_full_house?(values) do
      case three_cards_same_value?(values) && contains_pair?(values) do
        false -> false
        true -> true
      end
    end

    defp three_cards_same_value?(values) do
      case Enum.count(values) == 5 do
        false -> false
        true -> Enum.any? values, fn v ->
          3 == Enum.count values, fn s -> s == v
        end
        end
      end
    end

    defp contains_pair?(values) do
      case Enum.count(values) == 5 do
        false -> false
        true ->
          values = Enum.map values, fn x -> @values_rank[x] end
          values = Enum.sort(values)

          values |> Enum.any?( fn v ->
            Enum.each @index, fn i ->
              v == Enum.at(values, i + 1)
            end
          end )
      end
    end


end
