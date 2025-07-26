#!/bin/bash

set -e

# Define a fallback ARN (can be manually verified to be stable)
DEFAULT_ARN="arn:aws:elasticbeanstalk:us-east-1::platform/Python 3.11 running on 64bit Amazon Linux 2023/4.6.1"

# Try to fetch the latest platform ARN
LATEST_ARN=$(aws elasticbeanstalk list-platform-versions \
  --region us-east-1 \
  --filters '[{"Type":"PlatformName","Operator":"Contains","Values":["Python"]}]' \
  --query "PlatformSummaryList[?contains(PlatformArn, 'Python 3.11 running')].[PlatformArn]" \
  --output text | grep '^arn:' | head -n 1 || true)

# Use fallback if command fails or output is empty
if [ -z "$LATEST_ARN" ]; then
  echo "Warning: Unable to retrieve latest platform ARN. Falling back to default."
  LATEST_ARN="$DEFAULT_ARN"
fi

# Output for Terraform external data source
jq -n --arg platform_arn "$LATEST_ARN" '{"platform_arn": $platform_arn}'