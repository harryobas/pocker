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
          rank == :full_house -> {hand_name, :full_house}
        end
    end

  end

  defp get_rank(suits, values) do
    case is_straight_flush?(suits, values) do
      true -> {:ok, :straight_flush}
      false ->
        case is_four_of_a_kind?(values) do
          true -> {:ok, :four_of_a_kind}
          false ->
            case is_full_house?(values) do
              true -> {:ok, :full_house}
              false -> :wrong
            end
        end
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
        values = Enum.map values, fn x -> @values_rank[x] end
        values |> Enum.uniq() |> Enum.count() == 2
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
        true ->
          values = Enum.map values, fn x -> @values_rank[x] end
          sorted_values = Enum.sort(values)
          case sorted_values |> Enum.take(3) |> Enum.uniq() |> length() == 1 do
            true -> true
            false -> case sorted_values |> Enum.reverse() |> Enum.take(3) |> Enum.uniq() |> length() == 1 do
              true -> true
              false -> false
            end
          end
      end
    end

    defp contains_pair?(values) do
      case Enum.count(values) == 5 do
        false -> false
        true ->
          values = Enum.map values, fn x -> @values_rank[x] end
          sorted_values = Enum.sort(values)
          case sorted_values |> Enum.chunk_every(2) |> Enum.any?(fn v -> v |> Enum.uniq() |> length() == 1 end) do
            true -> true
            false ->
              case sorted_values |> Enum.reverse() |> Enum.chunk_every(2) |> Enum.any?(fn v -> v |> Enum.uniq() |> length()end) do
                true -> true
                false -> false
              end
          end
      end
    end


end
