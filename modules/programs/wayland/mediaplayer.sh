#!/usr/bin/env bash

# Function to get YouTube Music info
get_youtube_music_info() {
    player_status=$(playerctl --player=chromium status 2>/dev/null)
    if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
        artist=$(playerctl --player=chromium metadata artist)
        title=$(playerctl --player=chromium metadata title)
        echo "{\"text\": \"$artist - $title\", \"class\": \"custom-youtube-music\", \"alt\": \"YouTube Music ($player_status)\"}"
    else
        echo ""
    fi
}

# Function to get ncmpcpp info
get_ncmpcpp_info() {
    if mpc status &>/dev/null; then
        current_song=$(mpc current)
        status=$(mpc status | sed -n 2p | awk '{print $1}' | tr -d '[]')
        if [ -n "$current_song" ]; then
            echo "{\"text\": \"$current_song\", \"class\": \"custom-ncmpcpp\", \"alt\": \"ncmpcpp ($status)\"}"
        else
            echo ""
        fi
    else
        echo ""
    fi
}

# Get info from both players
youtube_music_info=$(get_youtube_music_info)
ncmpcpp_info=$(get_ncmpcpp_info)

# Determine which player to display (prioritize YouTube Music)
if [ -n "$youtube_music_info" ]; then
    echo "$youtube_music_info"
elif [ -n "$ncmpcpp_info" ]; then
    echo "$ncmpcpp_info"
else
    echo "{\"text\": \"No music playing\", \"class\": \"custom-media\", \"alt\": \"No player active\"}"
fi
