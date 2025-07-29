aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output json --profile prod > AWS/assets/log-groups-prod.json

# Ensure [profile prod] already exists in ~/.aws/credentials
# All dev, staging and prod env belongs to the prod account