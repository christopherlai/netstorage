defmodule NetStorage.Headers do
  @version Keyword.get(Mix.Project.config(), :version)
  @default_headers [
    {"Accept", "application/xml"},
    {"Accept-Encoding", "identity"},
    {"User-Agent", "Elixir NetStorage Client #{@version}"}
  ]

  def build(op, config, full_path, uuid \\ :rand.uniform(100_000)) do
    acs_action = "version=#{op.version}&action=#{op.action}"
    acs_auth_data = "5, 0.0.0.0, 0.0.0.0, #{current_timestamp()}, #{uuid}, #{config.account_id}"
    sign_string = "#{full_path}\nx-akamai-acs-action:#{acs_action}\n"
    message = "#{acs_auth_data}#{sign_string}"

    hash = :crypto.mac(:hmac, :sha256, config.key, message)

    acs_auth_sign = Base.encode64(hash)

    @default_headers ++
      [
        {"X-Akamai-ACS-Action", acs_action},
        {"X-Akamai-ACS-Auth-Data", acs_auth_data},
        {"X-Akamai-ACS-Auth-Sign", acs_auth_sign}
      ]
  end

  defp current_timestamp, do: DateTime.utc_now() |> DateTime.to_unix()
end
