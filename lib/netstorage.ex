defmodule NetStorage do
  alias NetStorage.Operation

  def delete(path, _opts \\ []), do: Operation.new(:put, "delete", path, & &1)
  def dir(path, _opts \\ []), do: Operation.new(:get, "dir", path, & &1)
  def download(path, _opts \\ []), do: Operation.new(:get, "dowload", path, & &1)
  def du(path, _opts \\ []), do: Operation.new(:get, "du", path, & &1)
  def list(path, _opts \\ []), do: Operation.new(:get, "list", path, & &1)
  def mkdir(path, _opts \\ []), do: Operation.new(:put, "mkdir", path, & &1)
  # def mtime(path, _opts \\ []), do: Operation.new(:post, "mtime", path, & &1)
  # def quick_delete(path, _opts \\ []), do: Operation.new(:post, "quick-delete", path, & &1)
  # def rename(path, _opts \\ []), do: Operation.new(:put, "rename", path, & &1)
  def rmdir(path, _opts \\ []), do: Operation.new(:put, "rmdir", path, & &1)
  def stat(path, _opts \\ []), do: Operation.new(:get, "stat", path, & &1)
  # def symlink(path, _opts \\ []), do: Operation.new(:post, "symlink", path, & &1)
  def upload(path, blob, _opts \\ []), do: Operation.new(:put, "upload", path, & &1, blob)

  def request(op, opts \\ []) do
    case NetStorage.Request.execute(op, opts) do
      {:ok, status, body} when status in [200, 204] ->
        {:ok, op.parser.(body)}

      {:ok, status, body} when status in [404] ->
        {:error, op.parser.(body)}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
