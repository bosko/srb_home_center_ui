defmodule SrbHomeCenterUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SrbHomeCenterUiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SrbHomeCenterUi.PubSub},
      # Start the Endpoint (http/https)
      SrbHomeCenterUiWeb.Endpoint
      # Start a worker by calling: SrbHomeCenterUi.Worker.start_link(arg)
      # {SrbHomeCenterUi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SrbHomeCenterUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SrbHomeCenterUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
