defmodule NetStorage.Operation do
  defstruct action: nil,
            body: "",
            method: nil,
            path: nil,
            version: 1,
            parser: nil

  def new(method, action, path, parser, body \\ "", version \\ 1) do
    struct(__MODULE__,
      method: method,
      action: action,
      path: path,
      body: body,
      version: version,
      parser: parser
    )
  end
end
