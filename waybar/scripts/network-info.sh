#!/usr/bin/env bash

# Waybar detailed network information
# Arch Linux + NetworkManager

set -u

INTERFACE=$(ip route | awk '/default/ {print $5; exit}')

if [[ -z "${INTERFACE:-}" ]]; then
    echo '{"text":"󰤮 Offline","tooltip":"No network connection","class":"offline"}'
    exit 0
fi

# Connection type
if [[ "$INTERFACE" == wl* ]]; then
    TYPE="Wi-Fi"
    ICON="󰤨"
else
    TYPE="Ethernet"
    ICON="󰈀"
fi

# NetworkManager connection
CONNECTION=$(nmcli -t -f GENERAL.CONNECTION device show "$INTERFACE" 2>/dev/null \
    | head -1 | sed 's/^GENERAL.CONNECTION://')

[[ -z "$CONNECTION" || "$CONNECTION" == "--" ]] && CONNECTION="Unknown"

# IPv4
IPV4=$(ip -4 -o addr show "$INTERFACE" 2>/dev/null \
    | awk '{print $4}' | cut -d/ -f1 | head -1)

[[ -z "${IPV4:-}" ]] && IPV4="None"

# IPv6
IPV6=$(ip -6 -o addr show "$INTERFACE" scope global 2>/dev/null \
    | awk '{print $4}' | cut -d/ -f1 | head -1)

[[ -z "${IPV6:-}" ]] && IPV6="None"

# Gateway
GATEWAY=$(ip route | awk '/default/ && $5=="'"$INTERFACE"'" {print $3; exit}')

[[ -z "${GATEWAY:-}" ]] && GATEWAY="None"

# MAC
MAC=$(cat "/sys/class/net/$INTERFACE/address" 2>/dev/null)

[[ -z "${MAC:-}" ]] && MAC="None"

# DNS
DNS=$(nmcli dev show "$INTERFACE" 2>/dev/null \
    | awk -F': ' '/IP4.DNS/ {print $2}' \
    | paste -sd ', ' -)

[[ -z "${DNS:-}" ]] && DNS="None"

# Wi-Fi information
SSID="N/A"
SIGNAL="N/A"
FREQUENCY="N/A"
BITRATE="N/A"
CHANNEL="N/A"

if [[ "$INTERFACE" == wl* ]]; then
    SSID=$(iw dev "$INTERFACE" link 2>/dev/null \
        | awk -F': ' '/SSID:/ {print $2}')

    SIGNAL=$(iw dev "$INTERFACE" link 2>/dev/null \
        | awk '/signal:/ {print $2}')

    FREQUENCY=$(iw dev "$INTERFACE" link 2>/dev/null \
        | awk '/freq:/ {print $2}')

    BITRATE=$(iw dev "$INTERFACE" link 2>/dev/null \
        | awk '/tx bitrate:/ {
            print $3 " " $4
            exit
        }')

    # Convert frequency to channel where possible
    if [[ "$FREQUENCY" =~ ^[0-9]+$ ]]; then
        CHANNEL=$(iw dev "$INTERFACE" info 2>/dev/null \
            | awk '/channel/ {print $2; exit}')
    fi

    [[ -z "${SSID:-}" ]] && SSID="Disconnected"
    [[ -z "${SIGNAL:-}" ]] && SIGNAL="N/A"
    [[ -z "${FREQUENCY:-}" ]] && FREQUENCY="N/A"
    [[ -z "${BITRATE:-}" ]] && BITRATE="N/A"
    [[ -z "${CHANNEL:-}" ]] && CHANNEL="N/A"
fi

# RX/TX bytes
RX=$(cat "/sys/class/net/$INTERFACE/statistics/rx_bytes" 2>/dev/null)
TX=$(cat "/sys/class/net/$INTERFACE/statistics/tx_bytes" 2>/dev/null)

# Store previous values
CACHE="/tmp/waybar-network-$INTERFACE"

if [[ -f "$CACHE" ]]; then
    read -r OLD_RX OLD_TX OLD_TIME < "$CACHE"

    NOW=$(date +%s%N)

    ELAPSED=$((NOW - OLD_TIME))

    if (( ELAPSED > 0 )); then
        RX_SPEED=$(( (RX - OLD_RX) * 8 * 1000000000 / ELAPSED ))
        TX_SPEED=$(( (TX - OLD_TX) * 8 * 1000000000 / ELAPSED ))
    else
        RX_SPEED=0
        TX_SPEED=0
    fi
else
    RX_SPEED=0
    TX_SPEED=0
fi

date +%s%N >/dev/null
NOW=$(date +%s%N)

echo "$RX $TX $NOW" > "$CACHE"

# Human readable speed
format_speed() {
    local speed=$1

    if (( speed >= 1000000000 )); then
        awk "BEGIN {printf \"%.1f Gbps\", $speed/1000000000}"
    elif (( speed >= 1000000 )); then
        awk "BEGIN {printf \"%.1f Mbps\", $speed/1000000}"
    elif (( speed >= 1000 )); then
        awk "BEGIN {printf \"%.1f Kbps\", $speed/1000}"
    else
        echo "${speed} bps"
    fi
}

RX_SPEED_H=$(format_speed "$RX_SPEED")
TX_SPEED_H=$(format_speed "$TX_SPEED")

# Human readable traffic
format_bytes() {
    numfmt --to=iec --suffix=B "$1" 2>/dev/null || echo "${1}B"
}

RX_TOTAL=$(format_bytes "$RX")
TX_TOTAL=$(format_bytes "$TX")

# VPN
if ip link show | grep -qE 'tun[0-9]*|wg[0-9]*|vpn'; then
    VPN="󰖂 Active"
else
    VPN="󰖂 None"
fi

# Signal icon
SIGNAL_ICON="󰤯"

if [[ "$SIGNAL" =~ ^-?[0-9]+$ ]]; then
    if (( SIGNAL >= -50 )); then
        SIGNAL_ICON="󰤨"
    elif (( SIGNAL >= -60 )); then
        SIGNAL_ICON="󰤥"
    elif (( SIGNAL >= -70 )); then
        SIGNAL_ICON="󰤢"
    else
        SIGNAL_ICON="󰤟"
    fi
fi

# Waybar text
if [[ "$TYPE" == "Wi-Fi" ]]; then
    TEXT="$SIGNAL_ICON $SSID ${SIGNAL}dBm"
else
    TEXT="$ICON $INTERFACE"
fi

# Tooltip
TOOLTIP="<b>󰤨 Network Information</b>\n"
TOOLTIP+="━━━━━━━━━━━━━━━━━━━━\n"
TOOLTIP+="<b>Connection:</b> $CONNECTION\n"
TOOLTIP+="<b>Type:</b> $TYPE\n"
TOOLTIP+="<b>Interface:</b> $INTERFACE\n"
TOOLTIP+="<b>IPv4:</b> $IPV4\n"
TOOLTIP+="<b>IPv6:</b> $IPV6\n"
TOOLTIP+="<b>Gateway:</b> $GATEWAY\n"
TOOLTIP+="<b>DNS:</b> $DNS\n"
TOOLTIP+="<b>MAC:</b> $MAC\n"
TOOLTIP+="\n"
TOOLTIP+="<b>󰖩 Traffic</b>\n"
TOOLTIP+="<b>Download:</b> $RX_SPEED_H\n"
TOOLTIP+="<b>Upload:</b> $TX_SPEED_H\n"
TOOLTIP+="<b>RX Total:</b> $RX_TOTAL\n"
TOOLTIP+="<b>TX Total:</b> $TX_TOTAL\n"

if [[ "$TYPE" == "Wi-Fi" ]]; then
    TOOLTIP+="\n"
    TOOLTIP+="<b>󰤨 Wi-Fi</b>\n"
    TOOLTIP+="<b>SSID:</b> $SSID\n"
    TOOLTIP+="<b>Signal:</b> $SIGNAL dBm\n"
    TOOLTIP+="<b>Frequency:</b> $FREQUENCY MHz\n"
    TOOLTIP+="<b>Channel:</b> $CHANNEL\n"
    TOOLTIP+="<b>Bitrate:</b> $BITRATE\n"
fi

TOOLTIP+="\n<b>󰖂 VPN:</b> $VPN"

# JSON escaping
TOOLTIP=$(printf '%s' "$TOOLTIP" | sed ':a;N;$!ba;s/\n/\\n/g')

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
    "$TEXT" "$TOOLTIP" "$TYPE"
