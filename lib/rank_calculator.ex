defmodule PockerOpdracht.RankCalculator do

  @moduledoc """
  provides functions cumputing the rank of a pocker hand
  """

  @spec compute_rank([{atom, String.t}]) :: {:ok, String.t, atom}
  def compute_rank(pocker_hand) do
    hand_name = pocker_hand |> Enum.into(%{}) |> Map.keys |> List.first |> to_string
    poker_hand = hd(pocker_hand)
    {_, deck} = poker_hand
    suits = deck |> String.split(" ") |> extract_suites
    case is_straight_flush?(suits) do
      true -> {:ok, hand_name, :straight_flush}
      _ -> :nomatch 
    end
  end

    defp extract_suites([head|tail]) do
      extracted = []
      suite_element = head |> String.split("") |> Enum.at(2)
      extracted = extracted ++ [suite_element]
      extract_suites(tail)
      extracted
    end

    defp extract_suites([]) do
    end

    defp is_straight_flush?(suite) when is_list(suite) do
      Enum.all?(suite, fn s -> s == hd(suite) end)
    end

    defp is_straight_flush?([]) do
      false
    end




  end
