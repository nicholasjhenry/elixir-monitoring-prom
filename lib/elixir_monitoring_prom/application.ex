defmodule ElixirMonitoringProm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    ElixirMonitoringProm.PhoenixInstrumenter.setup()
    ElixirMonitoringProm.PipelineInstrumenter.setup()
    ElixirMonitoringProm.RepoInstrumenter.setup()
    ElixirMonitoringProm.PrometheusExporter.setup()
    ElixirMonitoringProm.Metrics.setup()

    # NOTE: Only for FreeBSD, Linux and OSX (experimental)
    # https://github.com/deadtrickster/prometheus_process_collector
    Prometheus.Registry.register_collector(:prometheus_process_collector)

    :telemetry.attach(
      "prometheus-ecto",
      [:elixir_monitoring_prom, :repo, :query],
      &ElixirMonitoringProm.RepoInstrumenter.handle_event/4,
      nil
    )

    children = [
      # Start the Ecto repository
      ElixirMonitoringProm.Repo,
      # Start the Telemetry supervisor
      ElixirMonitoringPromWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirMonitoringProm.PubSub},
      # Start the Endpoint (http/https)
      ElixirMonitoringPromWeb.Endpoint
      # Start a worker by calling: ElixirMonitoringProm.Worker.start_link(arg)
      # {ElixirMonitoringProm.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMonitoringProm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirMonitoringPromWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
