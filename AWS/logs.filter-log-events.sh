aws logs filter-log-events --log-group-name /aws/lambda/foxden-payment-v2-2022-06-30-dev-graphql \
  --start-time $(date -d '2025-09-25 01:30:00' +%s000) \
  --end-time $(date -d '2025-09-26 00:00:00' +%s000) \
  --filter-pattern "" --output json --profile prod > AWS/assets/payment/dev-20250925-01.json

# Ensure [profile prod] already exists in ~/.aws/credentials
# All dev, staging and prod env belongs to the prod account
# local time

# /aws/lambda/foxden-billing-dev-renewal-billing renewal in billing job.
# /aws/lambda/foxden-billing-prod-renewal-billing
# /aws/lambda/foxden-admin-dev-graphql
# /aws/lambda/foxden-payment-v2-2022-06-30-dev-graphql
# /aws/lambda/underwriting-2022-06-30-dev-graphql
# /aws/lambda/foxden-billing-prod-billing
# /aws/lambda/foxden-billing-prod-renewal-billing
# /aws/lambda/policydocument-2022-06-30-dev-graphql
# foxden-auth-logs-production
# /aws/lambda/foxden-admin-prod-graphql
# /aws/lambda/rating-quoting-2022-06-30-dev-graphql