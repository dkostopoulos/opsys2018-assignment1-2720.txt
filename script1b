#!/bin/bash

initialize() {
    mkdir -p ~/.site-tester
    mkdir -p ~/.site-tester/cache
}

checkUrl() {
    url="$1"

    tmpfile="/tmp/site-content-temp-$RANDOM.html"
    cachefile="$HOME/.site-tester/cache/$( echo $url | sha256sum )"

    touch $cachefile

    if curl "$url" > "$tmpfile" 2>/dev/null
    then
        if [ -f "$cachefile" ]
        then if diff "$tmpfile" "$cachefile" &>/dev/null
          then
              :
          else
              echo "$url"
          fi
        else
            echo "$url" INIT
        fi
    else
      if [ -f "$cachefile" ]
      then if diff "$tmpfile" "$cachefile" &>/dev/null
        then
            :
        else
            echo "$url" FAILED
        fi
      else
          echo "$url" FAILED INIT
      fi
    fi
    cat "$tmpfile" > "$cachefile"
    rm "$tmpfile"
}

initialize

while IFS='' read -r line || [[ -n "$line" ]]
do
    [[ "$line" = \#* ]] && continue || checkUrl $line &
done < "$1"

wait

