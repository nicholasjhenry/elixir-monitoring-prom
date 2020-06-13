defmodule ElixirMonitoringProm.PhoenixInstrumenter do
  @moduledoc "Prometheus instrumenter for Phoenix"

  use Prometheus.PhoenixInstrumenter
end

defmodule ElixirMonitoringProm.PipelineInstrumenter do
  @moduledoc "Prometheus instrumenter for Phoenix"

  use Prometheus.PlugPipelineInstrumenter

  def label_value(:request_path, conn) do
    case Phoenix.Router.route_info(
           ElixirMonitoringPromWeb.Router,
           conn.method,
           conn.request_path,
           ""
         ) do
      %{route: path} -> path
      _ -> "unkown"
    end
  end
end

defmodule ElixirMonitoringProm.RepoInstrumenter do
  @moduledoc "Prometheus instrumenter for Phoenix"

  use Prometheus.EctoInstrumenter
end

defmodule ElixirMonitoringProm.PrometheusExporter do
  @moduledoc "Prometheus instrumenter for Phoenix"

  use Prometheus.PlugExporter
end
