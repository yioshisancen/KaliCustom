#!/usr/bin/sh

## Custom Script to monitor the VPN status

IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')

if [ "$IFACE" = "tun0" ]; then
    echo "%{F#43a047}󰗹 %{F#43a047}$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{u-}"
else
    echo "%{F#FFF000}󰁵 %{u-}VPN Disconnected"
fi
