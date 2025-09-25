# Define prefix array
prefix_array=(
  "/aws/lambda/underwriting-2022-06-30-prod"
  "/aws/lambda/rating-quoting-2022-06-30-prod"
  "/aws/lambda/foxden-payment-v2-2022-06-30-prod"
  "/aws/lambda/policydocument-2022-06-30-prod"
  "/aws/lambda/foxden-admin-prod-graphql"
  "/aws/lambda/foxden-billing-prod"
  "foxden-auth-logs-production"
  # Add more prefixes here
)

# Read log group names from JSON file
log_group_list=$(jq -r '.[]' ./AWS/assets/log-groups-prod.json)

# Filter log group names by prefix
filtered_log_groups=()
for log_group_name in $log_group_list; do
  for prefix in "${prefix_array[@]}"; do
    if [[ "$log_group_name" == "$prefix"* ]]; then
      filtered_log_groups+=("$log_group_name")
      break
    fi
  done
done

# Set month and year
year=2025
month=09
# Get last day of the month
last_day=$(cal $month $year | awk 'NF {DAYS = $NF}; END {print DAYS}')

# Loop through each day of the month
for day in $(seq -w 1 $last_day); do
  start_time=$(date -d "$year-$month-$day 00:00:00" +%s000)
  end_time=$(date -d "$year-$month-$day 23:59:00" +%s000)
  date_str="$year-$month-$day"
  date_folder="AWS/assets/EMFILE/${date_str}"
  mkdir -p "$date_folder"
  for log_group_name in "${filtered_log_groups[@]}"; do
    file_name="EMFILE-$(echo "$log_group_name" | tr '/' '-').json"
    echo "Processing log group: $log_group_name for date: $date_str"
    tmp_log=$(aws logs filter-log-events \
      --log-group-name "$log_group_name" \
      --start-time "$start_time" \
      --end-time "$end_time" \
      --filter-pattern "EMFILE" \
      --output json \
      --profile prod)
    # Exclude events containing '[EMFILE investigation]'
    filtered_log=$(echo "$tmp_log" | jq 'if .events then .events |= map(select(.message | contains("[EMFILE investigation]") | not)) else . end')
    event_count=$(echo "$filtered_log" | jq '.events | length')
    if [ $event_count -gt 0 ]; then
      echo "$filtered_log" > "${date_folder}/${file_name}"
      # Print in red
      echo -e "\033[31mHas events for $log_group_name on $date_str, file generated.\033[0m"
    else
      # Print in green
      echo -e "\033[32mNo events for $log_group_name on $date_str, skipping file.\033[0m"
    fi
  done
done