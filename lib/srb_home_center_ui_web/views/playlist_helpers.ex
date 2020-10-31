defmodule SrbHomeCenterUiWeb.PlaylistHelpers do
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

  def status_flag_class(status, flag) do
    cond do
      flag == :volume && Keyword.get(status, flag) == "0" ->
        "orange"

      flag != :volume && Keyword.get(status, flag) == "1" ->
        "orange"

      true ->
        ""
    end
  end
end
