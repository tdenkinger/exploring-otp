defmodule SequenceTest do
  use ExUnit.Case
  doctest Sequence

  describe "Sequence server" do
    setup do
      :sys.replace_state(Sequence.Server, fn {_old_state, pid} -> {0, pid} end)
      :ok
    end

    test "returns the first number when called" do
      {start_value, _} =  :sys.get_state Sequence.Server
      new_value = Sequence.Server.next_number
      assert new_value == start_value
    end

    test "increments the number on subsequent calls" do
      {start_value, _} =  :sys.get_state Sequence.Server
      _ = Sequence.Server.next_number
      new_value = Sequence.Server.next_number
      assert new_value == start_value + 1
    end
  end
end
