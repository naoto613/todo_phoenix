defmodule TodoPhoenix.Todo do
  import Ecto.Query, warn: false
  alias TodoPhoenix.Repo
  alias TodoPhoenix.Todo.Task

  @doc """
  タスク一覧を取得する。
  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  タスクを作成する。
  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_tables() do
    target = "content"

    File.stream!("test.csv")
    |> Enum.reduce(Ecto.Multi.new(), fn line, multi ->
      [id, value_str] = String.trim_trailing(line) |> String.split(",")
      value = String.trim(value_str)

      case Enum.find([Task], fn x -> target in Enum.map(x.__schema__(:fields), &to_string/1) end) do
        Task ->
          update_table(Task, id, target, value, multi)
        nil ->
          {:error, "Invalid target"}
      end
    end)
    |> Repo.transaction()
  end


  defp update_table(table, id, target, value, multi) do
    data = Repo.get(table, id)
    changeset = table.changeset(data, Map.new([{target, value}]))

    if String.length(value) <= 50 do
      Ecto.Multi.update(multi, "task_#{id}", changeset)
    else
      multi
    end
  end
end
