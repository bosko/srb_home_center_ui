defmodule SrbHomeCenterUiWeb.MediaLive do
  use SrbHomeCenterUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    :timer.send_interval(5000, self(), :tick)
    {:ok, assign(socket, results: %{current_time: Time.utc_now()})}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, assign(socket, results: %{current_time: Time.utc_now()})}
  end
end
