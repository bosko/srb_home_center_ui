defmodule SrbHomeCenterUiWeb.MediaLive do
  use SrbHomeCenterUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Mpdex.configure(Application.get_env(:mpdex, :media_server))
    {:ok, assign(socket, lists: Mpdex.Playlists.list(), loaded_list: nil, songs: [])}
  end

  @impl true
  def handle_event("select_list", %{"selected-list" => list_name}, socket) do
    {:ok, songs} = Mpdex.Playlists.get(list_name)
    socket = assign(socket, loaded_list: list_name, songs: songs)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply,
     assign(socket, lists: [[{:playlist, "nova"}]])}
  end
end
