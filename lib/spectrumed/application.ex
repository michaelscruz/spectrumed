defmodule Spectrumed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SpectrumedWeb.Telemetry,
      Spectrumed.Repo,
      {DNSCluster, query: Application.get_env(:spectrumed, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Spectrumed.PubSub},
      # Start a worker by calling: Spectrumed.Worker.start_link(arg)
      # {Spectrumed.Worker, arg},
      # Start to serve requests, typically the last entry
      SpectrumedWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spectrumed.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpectrumedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
