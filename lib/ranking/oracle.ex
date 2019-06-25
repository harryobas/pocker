defmodule PockerOpdracht.Ranking.Oracle do

  @moduledoc """
  provides functions cumputing the rank of a pocker hand
  """

  @values_map %{
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

  @suits  ["C", "D", "H", "S"]

  def compute_rank(pocker_hand) do
    hand_name =
      pocker_hand
      |> Enum.into(%{})
      |> Map.keys
      |> List.first
      |> to_string

    poker_hand = hd(pocker_hand)
    {_, cards} = poker_hand
    suits = cards |> String.split(" ") |> extract_suites
    values = cards |> String.split(" ") |> extract_values

    case is_valid_pocker_hand?(values, suits) do
      false -> {:error, "invalid_pocker_hand"}
      true ->
        case get_rank(suits, values) do
          {:ok, rank} ->
            cond do
              rank == :straight_flush -> {hand_name, :straight_flush, values}
              rank == :four_of_a_kind -> {hand_name, :four_of_a_kind, values}
              rank == :full_house -> {hand_name, :full_house, values}
              rank == :flush -> {hand_name, :flush, values}
              rank == :straight -> {hand_name, :straight, values}
              rank == :three_of_a_kind -> {hand_name, :three_of_a_kind, values}
              rank == :two_pairs -> {hand_name, :two_pairs, values}
              rank == :pair -> {hand_name, :pair, values}
              rank == :high_card -> {hand_name, :high_card, values}
            end
          end
        end
      end


  defp get_rank(suits, values) do
    cond do
      is_straight_flush?(suits, values) -> {:ok, :straight_flush}
      is_four_of_a_kind?(values) -> {:ok, :four_of_a_kind}
      is_full_house?(values) -> {:ok, :full_house}
      is_flush?(suits) -> {:ok, :flush}
      is_straight?(values) -> {:ok, :straight}
      is_three_of_a_kind?(values) -> {:ok, :three_of_a_kind}
      is_two_pairs?(values) -> {:ok, :two_pairs}
      is_pair?(values) -> {:ok, :pair}

      is_high_card?(suits, values) -> {:ok, :high_card}
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
    case same_suits?(suits) && five_consecutive_values?(values) do
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

  defp five_consecutive_values?([]) do
    false
  end

  defp five_consecutive_values?(values) do

    values = values |> Enum.map(fn v -> @values_map[v]end)
    values = List.to_tuple(values)
    elem(values, 0) + 1 == elem(values, 1) &&
    elem(values, 1) + 1 == elem(values, 2) &&
    elem(values, 2) + 1 == elem(values, 3) &&
    elem(values, 3) + 1 == elem(values, 4)

  end

  defp is_four_of_a_kind?(values) do
    case Enum.count(values) == 5 do
      false -> false
      true ->
        Enum.any? values, fn v ->
          4 == Enum.count values, fn s -> s == v end
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
        true -> Enum.any? values, fn v ->
          2 == Enum.count values, fn s -> s == v
        end
      end
      end
    end

    defp is_flush?(suits) do
      same_suits?(suits)
    end

    defp is_straight?(values) do
      five_consecutive_values?(values)
    end

    defp is_three_of_a_kind?(values) do
      three_cards_same_value?(values)
    end

    defp is_two_pairs?(values) do
      case Enum.count(values) == 5 do
        false ->  false
        true -> cond do
          values |> Enum.uniq() |> length() == 2 or values
          |> Enum.uniq() |> length() == 3 ->
            true
          true ->
            false
        end
      end
    end

    defp is_pair?(values) do
      contains_pair?(values)
    end

    defp is_high_card?(suits, values) do
      !is_straight_flush?(suits, values) &&
      !is_four_of_a_kind?(values) &&
      !is_full_house?(values) &&
      !is_flush?(suits) &&
      !is_straight?(values) &&
      !is_three_of_a_kind?(values) &&
      !is_two_pairs?(values) &&
      !is_pair?(values)

    end

    defp is_valid_pocker_hand?(values, suits) do
      values |> Enum.all?(fn v -> Enum.member?(Map.keys(@values_map), v)end) &&
      suits |> Enum.all?(fn s -> Enum.member?(@suits, s)end)
    end

    def values_map do
      @values_map
    end


  end
