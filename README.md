# AWS_SSO_Terraform_Environment_Export

This script helps you get logged into aws via aws sso and refresh your token, and export your environment variables so that you can use terraform.

This script (or similar) is necessary if you are using Terraform with AWS SSO due to unresolved issues with the way Terraform parses and uses the cli and sso cache files.
