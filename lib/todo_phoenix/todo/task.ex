defmodule TodoPhoenix.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_tasks" do
    field :content, :string
    field :state, :integer

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:content, :state])
    |> validate_required([:content, :state])
  end
end
