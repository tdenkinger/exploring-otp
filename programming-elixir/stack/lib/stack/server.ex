defmodule Stack.Server do
  use GenServer

  def start_link(starting_stack) do
    GenServer.start_link(__MODULE__, starting_stack, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(values) when is_list(values )do
    GenServer.cast(__MODULE__, {:push_list, values})
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})
  end

  def handle_call(:pop, _from, current_stack) do
    if Enum.empty?(current_stack) do
      terminate("Stack is exhausted", current_stack)
    end

    {:reply, List.first(current_stack), List.delete_at(current_stack, 0)}
  end

  def handle_cast({:push, val}, current_stack) do
    if val == "boom" do
      terminate(val, current_stack)
    end

    {:noreply, List.insert_at(current_stack, 0, val)}
  end

  def handle_cast({:push_list, list}, current_stack) do
    {:noreply, list ++ current_stack}
  end

  def terminate("boom", _current_stack) do
    System.halt(1)
  end

  def terminate(reason, _current_stack) do
    IO.puts reason
  end
end
