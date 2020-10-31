defmodule SrbHomeCenterUiWeb.MediaLive do
  use SrbHomeCenterUiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Mpdex.configure(Application.get_env(:mpdex, :media_server))
    player_status = Mpdex.status()
    {:ok, queue} = Mpdex.queue()

    status = %{
      lists: Mpdex.list(),
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
      {:noreply, assign(socket, loaded_list: nil, songs: [])}
    else
      {:ok, songs} = Mpdex.get(list_name)
      {:noreply, assign(socket, loaded_list: list_name, songs: songs)}
    end
  end

  @impl true
  def handle_event("add-to-queue", %{"file" => file}, socket) do
    Mpdex.add_to_queue(file)

    {:ok, queue} = Mpdex.queue()
    {:noreply, assign(socket, :queue, queue)}
  end

  @impl true
  def handle_event("replace-queue", %{"file" => file}, socket) do
    Mpdex.clear()
    Mpdex.add_to_queue(file)

    {:ok, queue} = Mpdex.queue()
    {:noreply, assign(socket, :queue, queue)}
  end

  @impl true
  def handle_event("play-previous", _, socket) do
    Mpdex.previous()

    {:ok, queue} = Mpdex.queue()
    player_status = Mpdex.status()

    socket =
      assign(socket,
        player_status: player_status,
        currently_playing: currently_playing(queue, player_status)
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("play-next", _, socket) do
    Mpdex.next()

    {:ok, queue} = Mpdex.queue()
    player_status = Mpdex.status()

    socket =
      assign(socket,
        player_status: player_status,
        currently_playing: currently_playing(queue, player_status)
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("inc_volume", _, socket) do
    change_volume(1)

    {:noreply, assign(socket, player_status: Mpdex.status())}
  end

  @impl true
  def handle_event("dec_volume", _, socket) do
    change_volume(-1)

    {:noreply, assign(socket, player_status: Mpdex.status())}
  end

  @impl true
  def handle_event("toggle_shuffle", _, socket) do
    case Keyword.get(Mpdex.status(), :random) do
      "0" ->
        Mpdex.shuffle_queue([])
        Mpdex.random_on()

      _ ->
        Mpdex.random_off()
    end

    {:noreply, assign(socket, player_status: Mpdex.status())}
  end

  @impl true
  def handle_event("toggle_mute", _, socket) do
    if Keyword.get(Mpdex.status(), :volume) != "0" do
      Mpdex.volume(0)
    else
      Mpdex.volume(1)
    end

    {:noreply, assign(socket, player_status: Mpdex.status())}
  end

  @impl true
  def handle_event("play_pause", _, socket) do
    case Keyword.get(Mpdex.status(), :state) do
      "stop" ->
        Mpdex.play(:position, 0)

      "pause" ->
        Mpdex.resume()

      "play" ->
        Mpdex.pause()
    end

    {:noreply, assign(socket, player_status: Mpdex.status())}
  end

  @impl true
  def handle_event("stop_playing", _, socket) do
    Mpdex.stop()

    {:noreply, assign(socket, player_status: Mpdex.status())}
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, assign(socket, lists: [[{:playlist, "nova"}]])}
  end

  defp currently_playing(queue, player_status) do
    song = String.to_integer(Keyword.get(player_status, :song, "0"))

    if song >= 0 do
      %{
        list: get_in(Enum.at(queue, song), [:metadata, :name]),
        song: get_in(Enum.at(queue, song), [:metadata, :title])
      }
    else
      %{list: "", song: ""}
    end
  end

  defp change_volume(amount) when is_integer(amount) do
    volume =
      Mpdex.status()
      |> Keyword.get(:volume)
      |> String.to_integer()

    if (amount == 1 && volume < 100) || (amount == -1 && volume > 0) do
      Mpdex.volume(volume + amount)
    end
  end
end
