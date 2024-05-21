defmodule LinksOrganizer do
  @moduledoc """
  Documentation for `LinksOrganizer`.
  """

  @doc """
  Start server

  ## Examples

      iex> LinksOrganizer.start()
      :world

  """
  def start do
    spawn(fn  -> loop(%{}) end)
  end

  def get_state(pid) do
    send(pid, {:state})
  end


  def filter_file(pid, in_file, delimiter) do
     send(pid, {:filter, in_file, delimiter})
  end

  def filter_and_save(in_file, delimiter) do
    lines = File.stream!(in_file)
      |> Enum.map(&String.trim/1)
      |> Enum.filter(&(String.last(&1) != delimiter))
      |> Enum.map(&String.trim_trailing/1)

      file_name = String.split(in_file, "/") |> List.last()

      output_name = "filtered_#{file_name}"
      content = Enum.join(lines, "\n")
      IO.puts("Filtering done. Saving into #{output_name}")
      File.write("outputs/#{output_name}", content)
      IO.puts("created #{output_name}")
      %{
        lines: content,
        count: Enum.count(lines)
      }
  end

  defp loop(state) do
    new_state = receive do
      {:state} ->
        IO.puts("The state")
        state
      {:filter, file, del} ->
        IO.puts("Filtering")
        filter_and_save(file, del)
      invalid_opt ->
        IO.puts("ERR invalid operation: #{invalid_opt}")
        state
    end
    # IO.inspect(new_state, label: "NEW: #{:rand.uniform()}")
    loop(new_state)
  end
end
