defmodule Card.Worker do
  use GenServer

  def start_link(arg) do
    IO.puts("Card.Worker is starting... ")
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def new() do
    GenServer.cast(__MODULE__, :new)
  end

  def shuffle() do
    GenServer.cast(__MODULE__, :shuffle)
  end

  def count() do
    GenServer.call(__MODULE__, :count)
  end

  def deal(n \\ 1) do
    GenServer.call(__MODULE__, {:deal, n})
  end

  def value() do
    GenServer.call(__MODULE__, :value)
  end

  @impl true
  def init(_arg) do
    {:ok, Card.Store.get() || new_deck()}
  end

  @impl true
  def handle_cast(:new, _state) do
    {:noreply, new_deck()}
  end

  @impl true
  def handle_cast(:shuffle, state) do
    {:noreply, Enum.shuffle(state)}
  end

  @impl true
  def handle_call(:count, _from, state) do
    {:reply, length(state), state}
  end

  @impl true
  def handle_call({:deal, n}, _from, _state) when not is_integer(n) do
    # IO.puts("Invalid number of cards requested. Must be an integer.")
    raise "Invalid argument for deal. Must be an integer."
  end

  @impl true
  def handle_call({:deal, n}, _from, state) when n >= 0 do
    if n <= length(state) do
      {dealt, remaining} = Enum.split(state, n)
      reply = {:ok, dealt}
      {:reply, reply, remaining}
    else
      reply = {:error, "Not enough cards in the deck"}
      {:reply, reply, state}
    end
  end

  @impl true
  def handle_call({:deal, _n}, _from, state) do
    reply = {:error, "Invalid number of cards requested"}
    {:reply, reply, state}
  end

  @impl true
  def handle_call(:value, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def terminate(_reason, value) do
    Card.Store.put(value)
  end

  defp new_deck() do
    new_deck =
      for i <- Enum.concat(2..10, [:jack, :queen, :king, :ace]),
          j <- [:spade, :heart, :club, :diamond],
          do: {i, j}
    new_deck
  end
end
