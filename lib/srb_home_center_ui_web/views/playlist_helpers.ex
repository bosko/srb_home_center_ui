defmodule SrbHomeCenterUiWeb.PlaylistHelpers do
  def display_song(song) do
    display = Enum.into(song, %{})

    [artist, album, title] = extract_from_file(display.file)

    display =
      if false == Map.has_key?(display.metadata, :artist) do
        put_in(display, [:metadata, :artist], artist)
      else
        display
      end

    display =
      if false == Map.has_key?(display.metadata, :album) do
        put_in(display, [:metadata, :album], album)
      else
        display
      end

    display =
      if false == Map.has_key?(display.metadata, :title) do
        put_in(display, [:metadata, :title], title)
      else
        display
      end

    if false == Map.has_key?(display.metadata, :duration) do
      put_in(display, [:metadata, :duration], 0)
    else
      display
    end
  end

  def display_duration(duration) do
    hours = floor(duration / 3600)
    minutes = floor((duration - hours * 3600) / 60)
    seconds = floor(duration - hours * 3600 - minutes * 60)

    hour_str = String.pad_leading(Integer.to_string(hours), 2, "0")
    min_str = String.pad_leading(Integer.to_string(minutes), 2, "0")
    sec_str = String.pad_leading(Integer.to_string(seconds), 2, "0")

    if hours == 0 do
      "#{min_str}:#{sec_str}"
    else
      "#{hour_str}:#{min_str}:#{sec_str}"
    end
  end

  def extract_from_file(file_path) do
    if String.starts_with?(file_path, "http") do
      ["Unknown", "Unknown", file_path]
    else
      paths = Path.dirname(file_path) |> String.split("/")

      [artist, album] =
        case length(paths) do
          1 ->
            [hd(paths), "Unknown"]

          2 ->
            paths

          _ ->
            [artist | [album | _]] = paths
            [artist, album]
        end

      name = Path.basename(file_path, Path.extname(file_path))

      [artist, album, name]
    end
  end

  def status_flag_class(status, flag) do
    if Keyword.get(status, flag) == "1" do
      "orange"
    else
      ""
    end
  end
end
