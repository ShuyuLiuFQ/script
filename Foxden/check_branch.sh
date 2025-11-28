#!/bin/bash

# Define colors
GREEN="\033[0;32m"
BLUE="\033[38;5;39m"
RESET="\033[0m"

# Define base paths
project_path="$HOME/Documents/Foxquilts"

# Define an array of repository paths
REPOS=(
  "foxcom-forms:3001"
  "foxcom-forms-backend:4002"
  "foxden-rating-quoting-backend:4007"
  "foxcom-payment-frontend:3000"
  "foxcom-payment-backend:4000"
  "foxden-policy-document-backend:4001"
  "foxden-admin-portal:3003"
  "foxden-admin-portal-backend:4005"
  "foxden-auth-service:3102"
  "foxden-version-controller:4006"
)

# Loop through each repository
for ENTRY in "${REPOS[@]}"; do
  IFS=':' read -r REPO PORT <<< "$ENTRY"
  REPO_PATH="$project_path/$REPO"

  echo "Checking $REPO..."
  cd "$REPO_PATH" || { echo "Failed to cd into $REPO_PATH"; continue; }

  # Check git status
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$BRANCH" == "master" ]]; then
    echo -e "${GREEN}On master branch. Pulling updates...${RESET}"
    git pull origin master
  else
    echo -e "${BLUE}On "$BRANCH" branch, not master. Skipping pull.${RESET}"
  fi
  echo "                                 "
done
