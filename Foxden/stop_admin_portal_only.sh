# Define colors
GREEN="\033[0;32m"
RESET="\033[0m"

# Define an array of repository paths
REPOS=(
  "foxden-admin-portal:3003"
  "foxden-admin-portal-backend:4005"
  "foxden-auth-service:3102"
  "foxden-version-controller:4006"
)

for ENTRY in "${REPOS[@]}"; do
  IFS=':' read -r REPO PORT <<< "$ENTRY"
  echo "Checking port $PORT for $REPO..."

  # Find the process ID (PID) running on the port and terminate it
  PID=$(lsof -t -i :"$PORT")
  if [[ -n "$PID" ]]; then
    echo "Killing process $PID running on port $PORT for $REPO..."
    kill -9 "$PID" && echo -e "${GREEN}Process $PID terminated.${RESET}"
  else
    echo "No process found on port $PORT for $REPO."
  fi

  echo "================================="
  echo "                                 "
done

echo "All specified ports have been processed."
