{ lix, pkgs, ... }:

lix.makeEwwConfig {
  defpolls = {
    active_workspace = {
      interval = "50ms";
      command = "hyprctl activeworkspace -j | jq '.id'";
    };
    occupied_workspaces = {
      interval = "50ms";
      initial = "[]";
      command = "hyprctl activewindow | sed -n 's/.*workspace: [^)]*(\([0-9]\+\)).*/\1/p'";
    };
    volume = {
      interval = "1s";
      command = "amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | tr -d '%'";
    };
    volume_muted = {
      interval = "1s";
      command = "amixer sget Master | grep -q '\\[off\\]' && echo 'true' || echo 'false'";
    };
    mic_status = {
      interval = "1s";
      command = "pamixer --default-source --get-mute";
    };
    time = {
      interval = "60s";
      command = "date '+%A %d %b %H:%M'";
    };
    ram_info = {
      interval = "2s";
      command = "free -h --giga | awk '/^Mem:/ {print $3\"/\"$2}' | sed 's/,/./g'";
    };
    cpu_info = {
      interval = "2s";
      command = "echo \"$(sensors | grep 'Package id 0:' | awk '{print $4}' | tr -d '+')\"";
    };
    gpu_info = {
      interval = "5s";
      command = "nvidia-smi --query-gpu=temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits | awk -F', ' '{printf \"%d°C %.1f/%.1fGB\", $1, $2/1024, $3/1024}'";
    };
    net_info = {
      interval = "2s";
      command = ''
        bash -c "
        RX1=\$(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+' | bc);
        TX1=\$(cat /sys/class/net/[ew]*/statistics/tx_bytes | paste -sd '+' | bc);
        sleep 1;
        RX2=\$(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+' | bc);
        TX2=\$(cat /sys/class/net/[ew]*/statistics/tx_bytes | paste -sd '+' | bc);
        RX=\$((\$RX2 - \$RX1));
        TX=\$((\$TX2 - \$TX1));
        printf '↓%4sB/s ↑%4sB/s' \$(numfmt --to=iec-i --format='%.1f' \$RX | sed 's/,/./g') \$(numfmt --to=iec-i --format='%.1f' \$TX | sed 's/,/./g')
        "
      '';
    };
    window_title = {
      interval = "1s";
      command = "hyprctl activewindow -j | jq -r '.title' | awk '{if (length($0) > 40) print substr($0, 1, 40) \"...\"; else print $0}'";
    };
    mpd_music = {
      interval = "1s";
      command = "mpc current -f '%artist% - %title%' | awk -F' - ' '{print $1 \" - \" (length($2) > 30 ? substr($2,1,27) \"...\" : $2)}' || echo ''";
    };
    mpd_status = {
      interval = "1s";
      command = "mpc status | awk '/\\[playing\\]/ {print \" \"} /\\[paused\\]/ {print \" \"}'";
    };
  };

  defvar.all_workspaces = "[1, 2, 3, 4, 5, 6, 7, 8, 9]";

  defwidgets = {
    window_title = {
      widget = "box";
      orientation = "horizontal";
      class = "window-title";
      children = [
        {
          widget = "label";
          text = "$\{window_title}";
        }
      ];
    };

    workspaces = {
      widget = "box";
      orientation = "h";
      halign = "start";
      space_evenly = false;
      children = [
        {
          widget = "for";
          list = "$\{all_workspaces}";
          item = "id";
          children = [
            {
              widget = "button";
              class = "workspace-button $\{id == active_workspace ? 'active' : ''} $\{occupied_workspaces =~ id ? 'occupied' : 'empty'}";
              style = "background-color: $\{id == active_workspace ? '#f08080' : ''};";
              onclick = "hyprctl dispatch workspace $\{id}";
              text = "$\{id}";
            }
          ];
        }
      ];
    };

    music = {
      widget = "box";
      class = "music";
      orientation = "h";
      space_evenly = false;
      halign = "center";
      children = [
        {
          widget = "label";
          text = "$\{mpd_status}";
        },
        {
          widget = "label";
          text = "$\{mpd_music != '' ? '󰝚  $\{mpd_music} 󰝚 ' : ''}";
        }
      ];
    };

    volume_mic = {
      widget = "box";
      class = "volume-mic";
      space_evenly = false;
      spacing = 5;
      children = [
        {
          widget = "label";
          text = "$\{volume_muted == 'true' ? ' ' : 
                   volume < 30 ? '' :
                   volume < 70 ? ' ' : ' '}";
        },
        {
          widget = "label";
          text = "$\{volume_muted == 'true' ? '' : '$\{volume}%'}";
        },
        {
          widget = "label";
          text = "$\{mic_status == 'true' ? ' ' : ' '}";
        }
      ];
    };

    sidestuff = {
      widget = "box";
      class = "sidestuff";
      orientation = "h";
      space_evenly = false;
      halign = "end";
      spacing = 25;
      children = [
        {
          widget = "eventbox";
          onclick = "kitty --class=floating-pm -e pulsemixer >/dev/null 2>&1 &";
          child = {
            widget = "box";
            class = "volume-mic";
            children = [
              {
                widget = "volume_mic";
              }
            ];
          };
        },
        {
          widget = "eventbox";
          onclick = "kitty --class=floating-btm -e btm >/dev/null 2>&1 &";
          child = {
            widget = "box";
            class = "ram";
            space_evenly = false;
            children = [
              {
                widget = "label";
                text = "  $\{ram_info}";
              }
            ];
          };
        },
        {
          widget = "eventbox";
          onclick = "kitty --class=floating-btm -e btm >/dev/null 2>&1 &";
          child = {
            widget = "box";
            class = "cpu";
            space_evenly = false;
            children = [
              {
                widget = "label";
                text = "  $\{cpu_info}";
              }
            ];
          };
        },
        {
          widget = "eventbox";
          onclick = "kitty --class=floating-nvidia-smi -e watch -n 1 nvidia-smi &";
          child = {
            widget = "box";
            class = "gpu";
            space_evenly = false;
            children = [
              {
                widget = "label";
                text = "  $\{gpu_info}";
              }
            ];
          };
        },
        {
          widget = "eventbox";
          onclick = "kitty --class=floating-nmtui -e nmtui >/dev/null 2>&1 &";
          child = {
            widget = "box";
            class = "net";
            space_evenly = false;
            children = [
              {
                widget = "label";
                text = "  $\{net_info}";
              }
            ];
          };
        },
        {
          widget = "box";
          class = "time";
          children = [
            {
              widget = "label";
              text = "$\{time}";
            }
          ];
        }
      ];
    };

    bar = {
      widget = "centerbox";
      orientation = "h";
      children = [
        {
          widget = "box";
          orientation = "h";
          space_evenly = false;
          halign = "start";
          children = [
            {
              widget = "workspaces";
            },
            {
              widget = "window_title";
            }
          ];
        },
        {
          widget = "music";
        },
        {
          widget = "sidestuff";
        }
      ];
    };
  };

  windows = {
    bar = {
      monitor = 0;
      windowtype = "dock";
      geometry = {
        x = "0%";
        y = "0%";
        width = "100%";
        height = "25px";
        anchor = "top center";
      };
      exclusive = true;
      children = [
        {
          widget = "bar";
        }
      ];
    };
  };

  css = ''
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
}
