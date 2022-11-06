#! /bin/sh

URL=https://${ICINGA_URL}:5665/v1
USERNAME=${ICINGA_USERNAME}
PASSWORD=${ICINGA_PASSWORD}

generate_host_data() {
  cat << EOF
{
  "attrs": {
    "address": "localhost",
    "check_command": "random",
    "vars.os": "$RAND"
  }
}
EOF
}

icinga_not_up=1

while [ $icinga_not_up -ne 0 ]
do
  sleep 5
  curl -ksSiu $USERNAME:$PASSWORD -H 'Accept: application/json' \
  -X GET $URL/status

  icinga_not_up=$?
done

iterator=1

while [ $iterator -le 100 ]
do
  echo "Creating example-host-$iterator..."
  
  RAND=$((1 + $RANDOM % 3))

  if [[ $RAND -eq 1 ]]
  then
    RAND="Linux"
  elif [[ $RAND -eq 2 ]]
  then
    RAND="Windows"
  else
    RAND="Printer"
  fi

  curl -ksSiu $USERNAME:$PASSWORD -H 'Accept: application/json' \
  -X PUT "$URL/objects/hosts/example-host-$iterator.local" \
  -d "$(generate_host_data)"

  curl -ksSiu $USERNAME:$PASSWORD -H 'Accept: application/json' \
  -X PUT "$URL/objects/services/example-host-$iterator.local!load" \
  -d '{"attrs": {"check_command": "random", "display_name": "Load Service"}}'

  curl -ksSiu $USERNAME:$PASSWORD -H 'Accept: application/json' \
  -X PUT "$URL/objects/services/example-host-$iterator.local!ping" \
  -d '{"attrs": {"check_command": "random", "display_name": "Ping Service"}}'

  curl -ksSiu $USERNAME:$PASSWORD -H 'Accept: application/json' \
  -X PUT "$URL/objects/services/example-host-$iterator.local!ssh" \
  -d '{"attrs": {"check_command": "random", "display_name": "SSH Service"}}'

  iterator=$(( $iterator + 1))
done