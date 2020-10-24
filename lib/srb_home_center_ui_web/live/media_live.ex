defmodule SrbHomeCenterUiWeb.MediaLive do
  use SrbHomeCenterUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Mpdex.configure(Application.get_env(:mpdex, :media_server))
    player_status = Mpdex.Status.status()
    {:ok, queue} = Mpdex.Queue.list()
    status = %{
      lists: Mpdex.Playlists.list(),
      loaded_list: nil,
      songs: [],
      player_status: player_status,
      currently_playing: currently_playing(queue, player_status),
      queue: queue
    }

    {:ok, assign(socket, status)}
  end

  @impl true
  def handle_event("select_list", %{"selected-list" => list_name}, socket) do
    if list_name == "" do
      socket = assign(socket, loaded_list: nil, songs: [])
      {:noreply, socket}
    else
      {:ok, songs} = Mpdex.Playlists.get(list_name)
      {:noreply, assign(socket, loaded_list: list_name, songs: songs)}
    end
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply,
     assign(socket, lists: [[{:playlist, "nova"}]])}
  end

  defp currently_playing(queue, player_status) do
    song = String.to_integer(Keyword.get(player_status, :song)) - 1
    if song >= 0 do
      %{
        list: get_in(Enum.at(queue, song), [:metadata, :name]),
        song: get_in(Enum.at(queue, song), [:metadata, :title])
      }
    else
      %{list: "", song: ""}
    end
  end
end
