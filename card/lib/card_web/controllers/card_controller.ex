defmodule CardWeb.CardController do
  use CardWeb, :controller

  def value(conn, _param) do
    cards = Card.Worker.value()
    formatted_cards = convert_to_list(cards)
    IO.inspect(formatted_cards)

    json(conn, formatted_cards)
  end

  def count(conn, _params) do
    count = Card.Worker.count()
    json(conn, %{"count" => count})
  end

  def shuffle(conn, _params) do
    Card.Worker.shuffle()
    send_resp(conn, 200, "shuffle deck")
  end

  def new(conn, _params) do
    Card.Worker.new()
    send_resp(conn, 200, "new deck")
  end

  def deal(conn, params) do
    qty = get_quantity(params)
    {status, cards} = deal_cards(qty)
    json(conn, %{"status: " => status, "deck: " => cards})
  end


defp deal_cards(qty) do
  case Card.Worker.deal(qty) do
    {:ok, cards} -> {"ok", convert_to_list(cards)}
    {:error, reason} -> {"error", reason}
  end
end

defp get_quantity(%{"qty" => qty}) when is_binary(qty), do: String.to_integer(qty)
defp get_quantity(%{"qty" => qty}) when is_integer(qty), do: qty
defp get_quantity(_), do: 1

defp convert_to_list(cards) do
  formatted_cards = Enum.map(cards, fn {value, suit} ->
    "#{value} #{suit}"
  end)
  formatted_cards
end

end
