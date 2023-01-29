defmodule Ogluna.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OglunaWeb.Telemetry,
      # Start the Ecto repository
      # Start the PubSub system
      {Phoenix.PubSub, name: Ogluna.PubSub},
      # Start Finch
      {Finch, name: Ogluna.Finch},
      # Start the Endpoint (http/https)
      OglunaWeb.Endpoint
      # Start a worker by calling: Ogluna.Worker.start_link(arg)
      # {Ogluna.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ogluna.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OglunaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
