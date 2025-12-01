#!/bin/bash

# Define colors
GREEN="\033[0;32m"
BLUE="\033[38;5;39m"
RESET="\033[0m"

# Define base paths
project_path="$HOME/Foxquilt"
log_path="$HOME/Foxquilt/Logs"
today=$(date +"%Y-%m-%d")

# Define an array of repository paths
REPOS=(
  "foxcom-forms-backend:4002"
  "foxden-rating-quoting-backend:4007"
  "foxden-auth-service:3102"
  "foxden-version-controller:4006"
)

# Ensure the log directory exists
mkdir -p "$log_path"

# Loop through each repository
for ENTRY in "${REPOS[@]}"; do
  IFS=':' read -r REPO PORT <<< "$ENTRY"
  REPO_PATH="$project_path/$REPO"
  REPO_LOG_DIR="$log_path/$REPO"
  LOG_FILE="$REPO_LOG_DIR/$today.log"

  echo "Processing $REPO..."
  cd "$REPO_PATH" || { echo "Failed to cd into $REPO_PATH"; continue; }

  # Create log directory for the repo
  mkdir -p "$REPO_LOG_DIR"

  # Check git status
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$BRANCH" == "master" ]]; then
    echo -e "${GREEN}On master branch. Pulling updates...${RESET}"
    git pull origin master
  else
    echo -e "${BLUE}On "$BRANCH" branch, not master. Skipping pull.${RESET}"
  fi

  # Run yarn commands and log output
  echo "Installing dependencies for $REPO..."
  yarn &>> "$LOG_FILE"

  echo "Starting server for $REPO on port $PORT..."
  yarn start &>> "$LOG_FILE" &  # Run in the background and log output
  echo "================================="
  echo "                                 "
done

# Check the ports at the end
echo "Checking ports..."
MAX_ATTEMPTS=12
DELAY=10

for ((i = 1; i <= MAX_ATTEMPTS; i++)); do
  echo "Port check attempt $i of $MAX_ATTEMPTS..."
  ALL_PORTS_READY=true

  for ENTRY in "${REPOS[@]}"; do
    IFS=':' read -r REPO PORT <<< "$ENTRY"
    if ! lsof -i :"$PORT" > /dev/null; then
      echo "Port $PORT for $REPO is not in use."
      ALL_PORTS_READY=false
    else
      echo -e "${GREEN}Port $PORT for $REPO is active.${RESET}"
    fi
  done

  # Exit loop early if all ports are ready
  if $ALL_PORTS_READY; then
    echo -e "${GREEN}All ports are ready!${RESET}"
    break
  fi

  # Wait before the next attempt
  if [[ $i -lt MAX_ATTEMPTS ]]; then
    echo "Waiting $DELAY seconds before next check..."
    echo "================================="
    sleep $DELAY
  fi

  echo "                                 "
done

echo "Port checking completed."
echo "================================="
echo "                                 "
sleep 3

## Stripe
# Log in to Stripe
echo "Do not forget to Log in to Stripe, you should run the command below:"
echo "\"stripe login --project-name us\""
echo "\"stripe listen --forward-to http://localhost:4000/local/2022-06-30/stripe/webhook-us --project-name us\""

