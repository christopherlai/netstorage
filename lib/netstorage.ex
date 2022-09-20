defmodule NetStorage do
  @moduledoc """
  Akamai NetStorage Usage API wrapper.

  Defaults to version 1. To change the version number, pass
  `[version: <version_number>]` to the `action_opts`.

  [Official Akamai Documentation](https://techdocs.akamai.com/netstorage-usage/reference/api)
  """

  @type path :: binary()
  @type action :: binary() | atom()
  @type action_opts :: keyword()
  @type request_opts :: keyword()

  alias NetStorage.Operation
  alias NetStorage.Parser

  @doc """
  Delete content

  [https://techdocs.akamai.com/netstorage-usage/reference/put-delete](https://techdocs.akamai.com/netstorage-usage/reference/put-delete)
  """
  @spec delete(path :: path(), opts :: action_opts()) :: any()
  def delete(path, opts \\ []) do
    [
      method: :put,
      action: :delete,
      path: path,
      parser: &Parser.parse_delete/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  List objects directly within the path.

  [https://techdocs.akamai.com/netstorage-usage/reference/get-dir](https://techdocs.akamai.com/netstorage-usage/reference/get-dir)
  """
  @spec dir(path :: path(), opts :: action_opts()) :: any()
  def dir(path, opts \\ []) do
    [
      method: :get,
      action: :dir,
      path: path,
      parser: &Parser.parse_dir/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Download a specified object.

  [https://techdocs.akamai.com/netstorage-usage/reference/get-download](https://techdocs.akamai.com/netstorage-usage/reference/get-download)
  """
  @spec download(path :: path(), opts :: action_opts()) :: any()
  def download(path, opts \\ []) do
    [
      method: :get,
      action: :download,
      path: path,
      parser: &Parser.parse_download/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Disk usage information for a specified path.

  [https://techdocs.akamai.com/netstorage-usage/reference/get-du](https://techdocs.akamai.com/netstorage-usage/reference/get-du)
  """
  @spec disk_usage(path :: path(), opts :: action_opts()) :: any()
  def disk_usage(path, opts \\ []) do
    [
      method: :get,
      action: :du,
      path: path,
      parser: &Parser.parse_du/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  List the objects directly within the specified path.

  [https://techdocs.akamai.com/netstorage-usage/reference/get-list](https://techdocs.akamai.com/netstorage-usage/reference/get-list)
  """
  @spec list(path :: path(), opts :: action_opts()) :: any()
  def list(path, opts \\ []) do
    [
      method: :get,
      action: :list,
      path: path,
      parser: &Parser.parse_list/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Create a new directory.

  [https://techdocs.akamai.com/netstorage-usage/reference/put-mkdir](https://techdocs.akamai.com/netstorage-usage/reference/put-mkdir)
  """
  @spec mkdir(path :: path(), opts :: action_opts()) :: any()
  def mkdir(path, opts \\ []) do
    [
      method: :put,
      action: :mkdir,
      path: path,
      parser: & &1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Change a the modification time ("touch") of an object.

  [https://techdocs.akamai.com/netstorage-usage/reference/post-mtime](https://techdocs.akamai.com/netstorage-usage/reference/post-mtime)
  """
  @spec touch(path :: path(), opts :: action_opts()) :: any()
  def touch(path, timestamp, opts \\ []) do
    [
      method: :post,
      action: [action: :mtime, mtime: timestamp],
      path: path,
      parser: &Parser.parse_mtime/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Delete of a selected directory, including all contents.

  Must pass `[confirm: :imreallyreallysure]` ops, otherwise this
  function will `noop`.

  [https://techdocs.akamai.com/netstorage-usage/reference/post-quick-delete](https://techdocs.akamai.com/netstorage-usage/reference/post-quick-delete)
  """
  @spec rmrf(path :: path(), opts :: action_opts()) :: any()
  def rmrf(path, opts \\ [])

  def rmrf(path, confirm: :imreallyreallysure) do
    rmrf(path, "quick-delete": "imreallyreallysure")
  end

  # "quick-delete scheduled\n"
  # "" noop
  def rmrf(path, opts) do
    [
      method: :post,
      action: "quick-delete",
      path: path,
      parser: & &1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Rename a specified object.

  The `destination` path must include the `Content Provier Code`.

      iex> NetStorage.rename("/path/to/file", "/<cp-code>/path/to/file")

  [https://techdocs.akamai.com/netstorage-usage/reference/put-rename](https://techdocs.akamai.com/netstorage-usage/reference/put-rename)
  """
  @spec rename(source :: path(), destination :: path(), opts :: action_opts()) :: any()
  # "Error processing destination: url_to_vn: root not found"
  # "Error processing destination: url_to_vn: Illegal duplicate /"
  # "renamed\n"
  def rename(source, destination, opts \\ []) do
    [
      method: :put,
      action: :rename,
      path: source,
      parser: & &1,
      opts: [destination: "#{destination}"] ++ opts
    ]
    |> Operation.new()
  end

  @doc """
  Delete an empty directory.

  [https://techdocs.akamai.com/netstorage-usage/reference/put-rmdir](https://techdocs.akamai.com/netstorage-usage/reference/put-rmdir)
  """
  @spec rmdir(path :: path(), opts :: action_opts()) :: any()
  def rmdir(path, opts \\ []) do
    [
      method: :put,
      action: :rmdir,
      path: path,
      parser: &Parser.parse_rmdir/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Information about a named file, symlink, or directory.

  [https://techdocs.akamai.com/netstorage-usage/reference/get-stat](https://techdocs.akamai.com/netstorage-usage/reference/get-stat)
  """
  @spec stat(path :: path(), opts :: action_opts()) :: any()
  def stat(path, opts \\ []) do
    [
      method: :get,
      action: :stat,
      path: path,
      parser: &Parser.parse_stat/1,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Create a symbolic link.

  [https://techdocs.akamai.com/netstorage-usage/reference/post-symlink](https://techdocs.akamai.com/netstorage-usage/reference/post-symlink)
  """
  @spec symlink(path :: path(), target :: path(), opts :: action_opts()) :: any()
  # "successful\n"
  def symlink(path, target, opts \\ []) do
    [
      method: :post,
      action: :symlink,
      path: path,
      parser: & &1,
      opts: [target: target] ++ opts
    ]
    |> Operation.new()
  end

  @doc """
  Upload content to specified path.

  [https://techdocs.akamai.com/netstorage-usage/reference/put-upload](https://techdocs.akamai.com/netstorage-usage/reference/put-upload)
  """
  @spec upload(path :: path(), blob :: binary(), opts :: action_opts()) :: any()
  def upload(path, blob, opts \\ []) do
    [
      method: :put,
      action: :upload,
      path: path,
      parser: &Parser.parse_upload/1,
      body: blob,
      opts: opts
    ]
    |> Operation.new()
  end

  @doc """
  Performs NetStorage request.
  """
  @spec request(operation :: Operation.t(), opts :: request_opts()) ::
          :ok | {:ok, term()} | :error | {:error, term()}
  def request(op, opts \\ []) do
    case NetStorage.Request.execute(op, opts) do
      {:ok, _status, body} ->
        op.parser.(body)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
