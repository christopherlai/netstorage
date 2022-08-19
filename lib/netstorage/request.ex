defmodule NetStorage.Request do
  alias NetStorage.Config
  alias NetStorage.HackneyClient
  alias NetStorage.Headers

  def execute(op, _opts \\ []) do
    config = Config.new()
    full_path = "/#{config.content_provider_code}#{op.path}"
    headers = Headers.build(op, config, full_path)
    url = "http://#{config.host}#{full_path}"

    HackneyClient.request(op.method, url, headers, op.body)
  end
end
