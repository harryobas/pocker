defmodule PockerOpdracht do

  @moduledoc """
  provides functionality to rank pairs of pocker hands
  and indicate which has the higher rank
  """

  alias PockerOpdracht.Ranking.Oracle
  alias PockerOpdracht.Ranking.RuleEngine


  def play(pocker_hand_one, pocker_hand_two) do
    hand_one = String.split(pocker_hand_one, " ")
    hand_two = String.split(pocker_hand_two, " ")

    {hand_one_name, hand_one_cards} = extract_player_name_and_cards(hand_one)
    {hand_two_name, hand_two_cards} = extract_player_name_and_cards(hand_two)

    player_one_hand = [{hand_one_name, hand_one_cards}]
    player_two_hand = [{hand_two_name, hand_two_cards}]

    report_winner(player_one_hand, player_two_hand)

  end

  defp extract_player_name_and_cards(hand) do
    hand_name = String.to_atom(hd(hand))
    hand_cards = Enum.join(tl(hand), " ")

    {hand_name, hand_cards}

  end

  defp report_winner(hand_one, hand_two) do
    case Oracle.compute_rank(hand_one) do
      {:error, "invalid_pocker_hand"} -> IO.puts "error: pocker hand is invalid"
      {name_one, rank_one, values_one} ->

        case Oracle.compute_rank(hand_two) do
          {:error, "invalid_pocker_hand"} -> IO.puts "error: pocker hand is invalid"
          {name_two, rank_two, values_two} ->

            case RuleEngine.winner({name_one, rank_one, values_one}, {name_two, rank_two, values_two}) do
              {:winner, player, rank} -> IO.puts "#{player} wins -  #{rank}"
              {:winner, "tie"} -> IO.puts "tie"

            end

          end

        end

  end


end
