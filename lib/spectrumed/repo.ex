defmodule Spectrumed.Repo do
  use Ecto.Repo,
    otp_app: :spectrumed,
    adapter: Ecto.Adapters.Postgres
end
