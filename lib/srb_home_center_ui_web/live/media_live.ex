defmodule SrbHomeCenterUiWeb.MediaLive do
  use SrbHomeCenterUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    player_status = Mpdex.status(Mpdex)
    queue =
      case Mpdex.queue(Mpdex) do
        {:ok, queue} ->
          queue

        {:error, _} ->
          []
      end

    lists = Mpdex.list(Mpdex)
    {:ok, songs} = Mpdex.get(Mpdex, hd(lists).playlist)
    status = %{
      active_tab: "player",
      lists: lists,
      loaded_list: hd(lists).playlist,
      songs: songs,
      player_status: player_status,
      currently_playing: currently_playing(queue, player_status),
      queue: queue
    }

    Mpdex.subscribe()

    {:ok, assign(socket, status)}
  end

  @impl true
  def handle_event("show_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end

  @impl true
  def handle_event("select_list", %{"selected-list" => list_name}, socket) do
    {:ok, songs} = Mpdex.get(Mpdex, list_name)
    {:noreply, assign(socket, loaded_list: list_name, songs: songs)}
  end

  @impl true
  def handle_event("add_to_queue", %{"file" => file}, socket) do
    Mpdex.add_to_queue(Mpdex, file)

    {:noreply, socket}
  end

  @impl true
  def handle_event("replace_queue", %{"file" => file}, socket) do
    Mpdex.clear(Mpdex)
    Mpdex.add_to_queue(Mpdex, file)

    {:noreply, socket}
  end

  @impl true
  def handle_event("play_previous", _, socket) do
    Mpdex.previous(Mpdex)

    {:noreply, socket}
  end

  @impl true
  def handle_event("play_next", _, socket) do
    Mpdex.next(Mpdex)

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc_volume", _, socket) do
    change_volume(1, socket.assigns.player_status)

    {:noreply, socket}
  end

  @impl true
  def handle_event("dec_volume", _, socket) do
    change_volume(-1, socket.assigns.player_status)

    {:noreply, socket}
  end

  # TODO: Move to notification based processing
  # currently it seems that MPD does not send notification
  # when random is set on or off
  @impl true
  def handle_event("toggle_shuffle", _, socket) do
    case Map.get(Mpdex.status(Mpdex), :random) do
      "0" ->
        Mpdex.shuffle_queue(Mpdex, [])
        Mpdex.random_on(Mpdex)

      _ ->
        Mpdex.random_off(Mpdex)
    end

    {:noreply, assign(socket, player_status: Mpdex.status(Mpdex))}
  end

  @impl true
  def handle_event("toggle_mute", _, socket) do
    if Map.get(socket.assigns.player_status, :volume) != "0" do
      Mpdex.volume(Mpdex, 0)
    else
      Mpdex.volume(Mpdex, 1)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("play_pause", _, socket) do
    case Map.get(socket.assigns.player_status, :state) do
      "stop" ->
        Mpdex.play(Mpdex, :position, 0)

      "pause" ->
        Mpdex.resume(Mpdex)

      "play" ->
        Mpdex.pause(Mpdex)

      _ ->
        nil
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop_playing", _, socket) do
    Mpdex.stop(Mpdex)

    {:noreply, socket}
  end

  @impl true
  def handle_event("queue_remove_song", %{"index" => index}, socket) do
    index = String.to_integer(index)
    Mpdex.remove_song(Mpdex, start: index)

    {:noreply, socket}
  end

  @impl true
  def handle_event("queue_play_song", %{"index" => index}, socket) do
    Mpdex.play(Mpdex, :position, index)

    {:noreply, socket}
  end

  @impl true
  def handle_event("mpd_reset_connection", _, socket) do
    send(Mpdex, {:tcp_closed, nil})

    {:noreply, socket}
  end

  @impl true
  def handle_info({:status, status}, socket) do
    socket =
      assign(socket,
        player_status: status,
        currently_playing: currently_playing(socket.assigns.queue, status)
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:queue, queue}, socket) do
    {:noreply, assign(socket, queue: queue)}
  end

  defp currently_playing(queue, player_status = %{}) do
    song = Map.get(player_status, :song, "-1") |> String.to_integer()

    if song >= 0 do
      %{
        list: get_in(Enum.at(queue, song), [:metadata, :name]),
        song: get_in(Enum.at(queue, song), [:metadata, :title])
      }
    else
      %{list: "", song: ""}
    end
  end

  defp change_volume(amount, status) when is_integer(amount) do
    volume = Map.get(status, :volume, "0") |> String.to_integer()

    if (amount == 1 && volume < 100) || (amount == -1 && volume > 0) do
      Mpdex.volume(Mpdex, volume + amount)
    end
  end
end
