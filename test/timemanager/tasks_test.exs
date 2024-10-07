defmodule Timemanager.TasksTest do
  use Timemanager.DataCase

  alias Timemanager.Tasks

  describe "tasks" do
    alias Timemanager.Tasks.Task

    import Timemanager.TasksFixtures

    @invalid_attrs %{description: nil, title: nil, due_date: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{description: "some description", title: "some title", due_date: ~N[2024-10-06 13:34:00]}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.description == "some description"
      assert task.title == "some title"
      assert task.due_date == ~N[2024-10-06 13:34:00]
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", due_date: ~N[2024-10-07 13:34:00]}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.description == "some updated description"
      assert task.title == "some updated title"
      assert task.due_date == ~N[2024-10-07 13:34:00]
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
