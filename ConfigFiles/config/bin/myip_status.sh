#!/usr/bin/env bash

 ##########################################################################
# ╔═╗┌─┐┬─┐┬┌─┐┌┬┐  ┌─┐┌─┐┬─┐┌─┐  ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌─┐  ┌┬┐┌─┐  ┬─┐┌─┐┌┬┐ #
# ╚═╗│  ├┬┘│├─┘ │   ├─┘├─┤├┬┘├─┤  ├┤ └─┐ │ ├─┤ │ │ │└─┐   ││├┤   ├┬┘├┤  ││ #
# ╚═╝└─┘┴└─┴┴   ┴   ┴  ┴ ┴┴└─┴ ┴  └─┘└─┘ ┴ ┴ ┴ ┴ └─┘└─┘  ─┴┘└─┘  ┴└─└─┘─┴┘ #
 ##########################################################################

# Icons de red
WIRED_ICON="󰈁"
WIRELESS_ICON="󰖩"
NO_CONNECTION_ICON="󰈂"

# Detectar interfaces de red
get_active_interface() {
  # Primero verificamos eth0 (alámbrica)
  if ip link show eth0 2>/dev/null | grep -q "state UP"; then
    echo "eth0"
  # Luego verificamos wlan0 (inalámbrica)
  elif ip link show wlan0 2>/dev/null | grep -q "state UP"; then
    echo "wlan0"
  elif ip link show ens33 2>/dev/null | grep -q "state UP"; then
    echo "ens33 up"
  else
    echo ""
  fi
}

# Obtener la dirección IP de la interfaz
get_interface_ip() {
  local interface=$1
  ip=$(ip -4 addr show "$interface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
  echo "$ip"
}

# Detectar la interfaz activa y conectada
INTERFACE=$(get_active_interface)

if [ -z "$INTERFACE" ]; then
  # No hay conexión de red
  echo "%{F#ff0000}$NO_CONNECTION_ICON Sin conexión%{F-}"
else
  # Hay conexión, obtenemos la IP
  IP=$(get_interface_ip "$INTERFACE")
  
  if [ -z "$IP" ]; then
    # Interfaz activa pero sin IP (quizá asignando)
    echo "%{F#ffff00}${INTERFACE}: Obteniendo IP...%{F-}"
  else
    # Mostramos según el tipo de conexión
    if [ "$INTERFACE" = "eth0" ]; then
      echo "%{F#55aa55}$WIRED_ICON $IP%{F-}"
    else
      echo "%{F#55aa55}$WIRELESS_ICON $IP%{F-}"
    fi
  fi
fi