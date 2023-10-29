defmodule CardWeb.CardController do
  use CardWeb, :controller

  def value(conn, _param) do
    IO.inspect(conn)
    value = Card.Worker.value()
    send_resp(conn, 200, value)
  end

  def count(conn, _params) do
    count = Card.Worker.count()
    json(conn, %{"count" => count})
  end

  def shuffle(conn, _params) do
    Card.Worker.shuffle()
    send_resp(conn, 200, "Deck shuffled")
  end

  def new(conn, _params) do
    Card.Worker.new()
    send_resp(conn, 200, "Spawned new deck")
  end

end
