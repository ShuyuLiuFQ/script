aws logs filter-log-events --log-group-name /aws/lambda/underwriting-2022-06-30-prod-graphql \
  --start-time $(date -d '2025-06-23 12:11:57' +%s000) \
  --end-time $(date -d '2025-06-23 12:19:00' +%s000) \
  --filter-pattern "" --output json --profile prod > AWS/assets/underwriting/underwriting-2022-06-30-prod-graphql-20250623-01.json

# Ensure [profile prod] already exists in ~/.aws/credentials
# All dev, staging and prod env belongs to the prod account
# local time

# /aws/lambda/foxden-billing-dev-renewal-billing renewal in billing job.
# /aws/lambda/foxden-billing-prod-renewal-billing
# /aws/lambda/foxden-admin-dev-graphql
# /aws/lambda/foxden-payment-v2-2022-06-30-dev-graphql
# /aws/lambda/underwriting-2022-06-30-prod-graphql
# /aws/lambda/foxden-billing-prod-billing
# /aws/lambda/foxden-billing-prod-renewal-billing
# /aws/lambda/policydocument-2022-06-30-dev-graphql
# foxden-auth-logs-production
# /aws/lambda/foxden-admin-prod-graphql