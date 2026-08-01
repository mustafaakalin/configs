#!/bin/bash

updates=$(checkupdates 2>/dev/null)
count=$(printf "%s\n" "$updates" | sed '/^$/d' | wc -l)

[ "$count" -eq 0 ] && updates="System is up to date"

updates=${updates//\\/\\\\}
updates=${updates//\"/\\\"}
updates=${updates//$'\n'/\\n}

printf '{"text":"%s","tooltip":"%s"}\n' "$count" "$updates"
