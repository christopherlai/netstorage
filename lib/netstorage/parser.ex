defmodule NetStorage.Parser do
  @moduledoc false

  import SweetXml

  def parse_delete("deleted\n" = message), do: handle_success(message)
  def parse_delete("not found\n" = reason), do: handle_error(reason)

  def parse_dir("Directory not found\n" = reason), do: handle_error(reason)

  def parse_dir(xml) do
    IO.inspect(xml)

    sub = [
      directory: ~x"./@directory"s,
      files: [
        ~x(./file[@type="file"])l,
        name: ~x"./@name",
        size: ~x"./@size",
        modified_timestamp: ~x"./@mtime"
      ],
      directories: [
        ~x(./file[@type="dir"])l,
        name: ~x"./@name",
        modified_timestamp: ~x"./@mtime"
      ],
      symlinks: [
        ~x(./file[@type="symlink"])l,
        name: ~x"./@name",
        target: ~x"./@target",
        modified_timestamp: ~x"./@mtime"
      ]
    ]

    {:ok, SweetXml.xpath(xml, ~x"/stat", sub)}
  end

  def parse_download("Not found\n" = reason), do: handle_error(reason)
  def parse_download(blob), do: handle_success(blob)

  def parse_du("Directory not found\n" = reason), do: handle_error(reason)

  def parse_du(xml) do
    sub = [
      directory: ~x"./@directory"s,
      files: ~x"./du-info/@files"i,
      bytes: ~x"./du-info/@bytes"i
    ]

    SweetXml.xpath(xml, ~x"//du", sub)
  end

  def parse_list("Directory not found\n" = reason), do: handle_error(reason)

  def parse_list(xml) do
    sub = [
      files: [
        ~x(./file[@type="file"])l,
        name: ~x"./@name"s,
        modified_timestamp: ~x"./@mtime"i,
        size: ~x"./@size"io,
        md5: ~x"./@md5"o
      ],
      directories: [
        ~x(./file[@type="dir"])l,
        name: ~x"./@name"
      ],
      symlinks: [
        ~x(./file[@type="symlink"])l,
        name: ~x"./@name"
      ]
    ]

    {:ok, SweetXml.xpath(xml, ~x"//list", sub)}
  end

  def parse_mtime("not found.\n" = reason), do: handle_error(reason)
  def parse_mtime("successful\n"), do: handle_success("")

  def parse_rmdir("Directory not empty\n" = reason), do: {:error, String.trim(reason)}
  def parse_rmdir("Directory not found\n" = reason), do: {:error, String.trim(reason)}
  def parse_rmdir("deleted\n" = message), do: handle_success(message)

  def parse_stat("Not found\n" = message), do: handle_error(message)

  def parse_stat(xml) do
    sub = [
      type: ~x"./file/@type"s,
      directory: ~x"./@directory"s,
      name: ~x"./file/@name"s,
      modified_timestamp: ~x"./file/@mtime"s,
      size: ~x"./file/@size"o,
      md5: ~x"./file/@md5"o
    ]

    SweetXml.xpath(xml, ~x"//stat", sub)
  end

  def parse_upload(message), do: handle_success(message)

  defp handle_success(""), do: :ok
  defp handle_success(message), do: {:ok, message |> String.trim() |> String.capitalize()}
  defp handle_error(reason), do: {:error, reason |> String.trim() |> String.capitalize()}
end
