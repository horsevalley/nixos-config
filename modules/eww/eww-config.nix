{ pkgs, ... }:

let
  eww-config = pkgs.writeText "eww.yuck" ''
    (defpoll active_workspace :interval "50ms"
      "hyprctl activeworkspace -j | jq '.id'")

    (defpoll occupied_workspaces :interval "50ms"
      :initial "[]"
      "hyprctl activewindow | sed -n 's/.*workspace: [^)]*(\([0-9]\+\)).*/\1/p'")

    (defpoll volume :interval "1s"
      "amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | tr -d '%'")

    (defpoll volume_muted :interval "1s"
      "amixer sget Master | grep -q '\\[off\\]' && echo 'true' || echo 'false'")

    (defpoll mic_status :interval "1s"
      "pamixer --default-source --get-mute")

    (defpoll time :interval "60s"
      "date '+%A %d %b %H:%M'")

    (defpoll ram_info :interval "2s"
      "free -h --giga | awk '/^Mem:/ {print $3\"/\"$2}' | sed 's/,/./g'")

    (defpoll cpu_info :interval "2s"
      "echo \"$(sensors | grep 'Package id 0:' | awk '{print $4}' | tr -d '+')\"")

    (defpoll gpu_info :interval "5s"
      "nvidia-smi --query-gpu=temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits | awk -F', ' '{printf \"%d°C %.1f/%.1fGB\", $1, $2/1024, $3/1024}'")

    (defpoll net_info :interval "2s"
      "bash -c \"
      RX1=\\$(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+' | bc);
      TX1=\\$(cat /sys/class/net/[ew]*/statistics/tx_bytes | paste -sd '+' | bc);
      sleep 1;
      RX2=\\$(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+' | bc);
      TX2=\\$(cat /sys/class/net/[ew]*/statistics/tx_bytes | paste -sd '+' | bc);
      RX=\\$((\\$RX2 - \\$RX1));
      TX=\\$((\\$TX2 - \\$TX1));
      printf '↓%4sB/s ↑%4sB/s' \\$(numfmt --to=iec-i --format='%.1f' \\$RX | sed 's/,/./g') \\$(numfmt --to=iec-i --format='%.1f' \\$TX | sed 's/,/./g')
      \"")

    (defpoll window-title :interval "1s"
      "hyprctl activewindow -j | jq -r '.title' | awk '{if (length($0) > 40) print substr($0, 1, 40) \"...\"; else print $0}'")

    (defpoll mpd_music :interval "1s"
      "mpc current -f '%artist% - %title%' | awk -F' - ' '{print $1 \" - \" (length($2) > 30 ? substr($2,1,27) \"...\" : $2)}' || echo ''")

    (defpoll mpd_status :interval "1s"
      "mpc status | awk '/\\[playing\\]/ {print \" \"} /\\[paused\\]/ {print \" \"}'")

    (defvar all_workspaces "[1, 2, 3, 4, 5, 6, 7, 8, 9]")

    (defwidget window-title []
      (box :orientation "horizontal"
           :class "window-title"
           (label :text window-title)))
      
    (defwidget workspaces []
      (box :orientation "h"
           :halign "start"
           :space-evenly false
        (for id in all_workspaces
          (button :class "workspace-button ''${id == active_workspace ? "active" : ""} ''${occupied_workspaces =~ id ? "occupied" : "empty"}"
                  :style "background-color: ''${id == active_workspace ? "#f08080" : ""};"
                  :onclick "hyprctl dispatch workspace ''${id}"
            "''${id}"))))

    (defwidget music []
      (box :class "music"
           :orientation "h"
           :space-evenly false
           :halign "center"
        (label :text "''${mpd_status}")
        (label :text {mpd_music != "" ? "󰝚  ''${mpd_music} 󰝚 " : ""})))

    (defwidget volume-mic []
      (box :class "volume-mic"
           :space-evenly false
           :spacing 5
        (label :text {volume_muted == "true" ? " " : 
                      volume < 30 ? "" :
                      volume < 70 ? " " : " "})
        (label :text {volume_muted == "true" ? "" : "''${volume}%"})
        (label :text {mic_status == "true" ? " " : " "})))

    (defwidget sidestuff []
      (box :class "sidestuff" 
           :orientation "h" 
           :space-evenly false 
           :halign "end"
           :spacing 25
        (eventbox :onclick "kitty --class=floating-pm -e pulsemixer >/dev/null 2>&1 &"
          (box :class "volume-mic"
            (volume-mic)))
        (eventbox :onclick "kitty --class=floating-btm -e btm >/dev/null 2>&1 &"
        (box :class "ram"
             :space-evenly false
          (label :text "  ''${ram_info}")))
        (eventbox :onclick "kitty --class=floating-btm -e btm >/dev/null 2>&1 &"
        (box :class "cpu"
             :space-evenly false
          (label :text "  ''${cpu_info}")))
        (eventbox :onclick "kitty --class=floating-nvidia-smi -e watch -n 1 nvidia-smi &"
        (box :class "gpu"
             :space-evenly false
          (label :text "  ''${gpu_info}")))
        (eventbox :onclick "kitty --class=floating-nmtui -e nmtui >/dev/null 2>&1 &"
        (box :class "net"
             :space-evenly false
          (label :text "  ''${net_info}")))
        (box :class "time" time)))

    (defwidget bar []
      (centerbox :orientation "h"
        (box :orientation "h"
             :space-evenly false
             :halign "start"
          (workspaces)
          (window-title))
        (music)
        (sidestuff)))

    (defwindow bar
      :monitor 0
      :windowtype "dock"
      :geometry (geometry :x "0%"
                          :y "0%"
                          :width "100%"
                          :height "25px"
                          :anchor "top center")
      :exclusive true
      (bar))
  '';

  eww-scss = pkgs.writeText "eww.scss" ''
    * {
      all: unset;
    }
    .bar {
      /* background-color: #1E1E2E; */
      font-size: 12px;
      font-weight: bold;
    }
    .window-title {
      padding-left: 5px;
    }
    .sidestuff {
      padding-right: 8px;
    }
    .workspace-button {
      padding: 0 5px;
      margin: 0 2px;
      border-radius: 0px;
      min-width: 15px;
      min-height: 15px;
      color: #FFFFFF;
      font-weight: bold;
      transition: all 0.01s ease;
    }
    .workspace-button.active {
      color: #FFFFFF;
    }
    .workspace-button.occupied {
      color: #FFFFFF;
    }
    .workspace-button.empty {
      color: #FFFFFF;
    }
  '';

in
{
  environment.systemPackages = [ pkgs.eww ];

  system.activationScripts.eww-config = ''
    mkdir -p /etc/eww
    ln -sf ${eww-config} /etc/eww/eww.yuck
    ln -sf ${eww-scss} /etc/eww/eww.scss
  '';
}
