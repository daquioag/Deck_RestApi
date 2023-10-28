defmodule Card.Store do
  use GenServer

  def start_link(file) do
    GenServer.start_link(MODULE, file, name: MODULE)
  end

  def get() do
    GenServer.call(MODULE, :get)
  end

  def put(value) do
    GenServer.cast(MODULE, {:put, value})
  end

  @impl true
  def init(file) do
    {:ok, file}
  end

  @impl true
  def handle_call(:get, _from, file) do
    reply =
      case File.read(file) do
        {:ok, content} ->
          :erlang.binary_toterm(content)
        {:error, } ->
          nil
      end
    {:reply, reply, file}
  end

  @impl true
  def handle_cast({:put, value}, file) do
    File.write(file, :erlang.term_to_binary(value))
    {:noreply, file}
  end

end
