defmodule Ogluna.Repo do
  use Ecto.Repo,
    otp_app: :ogluna,
    adapter: Ecto.Adapters.Postgres
end
