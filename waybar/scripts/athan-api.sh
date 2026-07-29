#!/usr/bin/env bash

set -e

# Koordinatlar (boş bırakılırsa IP üzerinden tespit eder)
LONG_LATI=""
# Eğer boşsa, IP ile tespit et
if [ -z "$LONG_LATI" ]; then
  LONG_LATI=$(curl -s http://ipinfo.io/json | jq -r '.loc')
fi

LATITUDE="36.474294"
LONGITUDE="34.37451"

# Tarih bilgileri
YEAR=$(date +%Y)
MONTH=$(date +%-m)
DAY=$(date +%-d)

# Şehir ve ülke bilgisi (Nominatim)
GEODATA=$(curl -s "https://nominatim.openstreetmap.org/reverse?lat=${LATITUDE}&lon=${LONGITUDE}&format=json&accept-language=ar" -A "geoapiExercises")
CITY=$(echo "$GEODATA" | jq -r '.address.city // .address.town // .address.village // .address.county // empty')
COUNTRY=$(echo "$GEODATA" | jq -r '.address.country')

# Ezan vakitleri
ATHAN=$(curl -s "http://api.aladhan.com/v1/calendar/${YEAR}/${MONTH}?latitude=${LATITUDE}&longitude=${LONGITUDE}&method=3")
TODAY=$(echo "$ATHAN" | jq ".data[$((DAY - 1))]")



# Eğer JSON geçerli değilse hatayı göster
if ! echo "$ATHAN" | jq -e .data > /dev/null; then
  echo "❌ Hatalı JSON yanıtı:"
  echo "$ATHAN"
  exit 1
fi


GREGORIAN=$(echo "$TODAY" | jq -r '.date.gregorian.date')
HIJRI=$(echo "$TODAY" | jq -r '.date.hijri.date')

FAJR=$(echo "$TODAY" | jq -r '.timings.Fajr')
SUNRISE=$(echo "$TODAY" | jq -r '.timings.Sunrise')
DHUHR=$(echo "$TODAY" | jq -r '.timings.Dhuhr')
ASR=$(echo "$TODAY" | jq -r '.timings.Asr')
MAGHRIB=$(echo "$TODAY" | jq -r '.timings.Maghrib')
ISHA=$(echo "$TODAY" | jq -r '.timings.Isha')

TOOLTIP=$(cat <<EOF
<b>المدينة: ${CITY}, ${COUNTRY} </b>\n
<b>ميلادي: ${GREGORIAN}</b>\n
<b>هجري: ${HIJRI}</b>\n
الفجر: ${FAJR}\n
الشروق: ${SUNRISE}\n
الظهر: ${DHUHR}\n
العصر: ${ASR}\n
المغرب: ${MAGHRIB}\n
العشاء: ${ISHA}
EOF
)

# JSON çıktısı
jq -n \
  --arg text "  🕋︎ " \
  --arg tooltip "$TOOLTIP" \
  '{text: $text, tooltip: $tooltip}'

