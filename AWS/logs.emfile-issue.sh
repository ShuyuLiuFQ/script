aws logs filter-log-events --log-group-name /aws/lambda/policydocument-2022-06-30-stage-graphql\
  --start-time $(date -d '2024-12-06 00:00:00' +%s000) \
  --end-time $(date -d '2024-12-07 00:00:00' +%s000) \
  --filter-pattern "" --output json --profile prod > AWS/assets/EMFILE_staging/EMFILE-1.json

# Ensure [profile prod] already exists in ~/.aws/credentials
# All dev, staging and prod env belongs to the prod account
# local time