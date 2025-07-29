# AWS
To configure AWS credentials for using AWS scripts, first store the `aws_access_key_id` and `aws_secret_access_key` for both `sandbox` and `prod` profiles in the `~/.aws/credentials` file. Then, specify the desired collection using the `--profile "sandbox"` parameter.

## Add a new script
1. Give execute permission to this new script: `chmod +x /path/to/yourscript.sh`.
2. Run the `shell` script by `./path/to/yourscript.sh`.