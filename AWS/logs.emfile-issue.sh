aws logs filter-log-events --log-group-name /aws/lambda/foxden-payment-v2-2022-06-30-dev-docuSign\
  --start-time $(date -d '2025-09-29 00:00:00' +%s000) \
  --end-time $(date -d '2025-09-30 00:00:00' +%s000) \
  --filter-pattern "" --output json --profile prod > AWS/assets/payment/dev-docuSign-20250929-01.json

# Ensure [profile prod] already exists in ~/.aws/credentials
# All dev, staging and prod env belongs to the prod account
# local time