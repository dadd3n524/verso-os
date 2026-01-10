#!/bin/bash

# --- Plex ---
if [ "$1" == "plex" ]; then
	echo -n "https://app.plex.tv/desktop" | wl-copy
	wtype -M ctrl -k l -m ctrl
	sleep 0.1
	wtype -M ctrl -k v -m ctrl
	sleep 0.1
	wtype -k Return
	sleep 0.5
	wtype -k F5
	exit 0
fi

# --- Guide Chaînes ---
if [ "$1" == "guide" ]; then
	echo -n "https://telustvplus.com/#/guide" | wl-copy
	wtype -M ctrl -k l -m ctrl
	sleep 0.1
	wtype -M ctrl -k v -m ctrl
	sleep 0.1
	wtype -k Return
	sleep 0.1
	wtype -k F5
	sleep 2.8
	wtype -M shift -k Tab -m shift
	exit 0
fi

# --- Chaînes ---
IDS=(
	206
	232
	728
	247
	237
	184
	817
	544
	185
	577
	128
	238
	239
	739
	569
	726
	643
	747
	654
	618
	638
	551
	648
	606
	581
	613
	640
	609
	243
	204
	207
	6
	1149
	588
	946
	930
    )

      # Construction automatique des liens
      CHAINES=()
      BASE_URL="https://telustvplus.com/#/player/live/?stationId="
      SUFFIXE="&contentType=LIVE&isLookBack=false"
     
      for id in "${IDS[@]}"; do CHAINES+=("${BASE_URL}${id}${SUFFIXE}")
      done

      # Mémoire de la chaîne actuelle
      TMP_FILE="/tmp/tv_index"
      if [ ! -f "$TMP_FILE" ]; then echo 0 > "$TMP_FILE"; fi
      CURRENT=$(cat "$TMP_FILE")
      TOTAL=${#CHAINES[@]}

      # Navigation Next/Prev
      if [ "$1" == "next" ]; then
	      NEXT=$(( (CURRENT - 1) % TOTAL))
      elif [ "$1" == "prev" ]; then
	      NEXT=$(( (CURRENT - 1 + TOTAL) % TOTAL))
      else
	      NEXT=0
      fi

      echo $NEXT > "$TMP_FILE"
      URL=${CHAINES[$NEXT]}

      # Copier-Coller dans le navigateur
      echo -n "$URL" | wl-copy
      wtype -M ctrl -k l -m ctrl
      sleep 0.1
      wtype -M ctrl -k v -m ctrl
      sleep 0.1

      # 2. Valide l'adresse (Entrée)
      wtype -k Return

      # 3. PAUSE ET RAFRAICHISSEMENT
      sleep 0.03
      wtype -k F5

