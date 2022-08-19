defmodule NetStorage.HackneyClient do
  def request(method, url, headers, body, opts \\ []) do
    case :hackney.request(method, url, headers, body, opts ++ [with_body: true]) do
      {:ok, status, _headers, body} ->
        {:ok, status, body}

      {:ok, status, _headers} ->
        {:ok, status, ""}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
