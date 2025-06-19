#!/usr/bin/env python3
"""
attach_password_change_policy.py

This script attaches the AWS-managed policy `IAMUserChangePassword` to all
manually created IAM groups in the current AWS account. It filters out known
system-managed and AWS-reserved groups based on naming conventions.

Intended for use in AWS CloudShell.

Attribution:
  Written as a collaborative effort between Romel Punsal and OpenAI ChatGPT,
  using AI-assisted peer programming to streamline IAM group policy automation.

Usage:
  python3 attach_password_change_policy.py
"""

import boto3
import botocore.exceptions

# Constants
PASSWORD_CHANGE_POLICY_ARN = 'arn:aws:iam::aws:policy/IAMUserChangePassword'

# Known system-managed or reserved IAM groups to skip
EXCLUDED_GROUPS = [
    "AWSControlTowerAdmins",
    "AWSControlTowerUsers",
    "AWSReservedSSO_AdministratorAccess",
    "AWSReservedSSO_ReadOnlyAccess",
    "AWSReservedSSO_PowerUserAccess"
]

def attach_policy_to_group(group_name):
    """
    Attaches the IAMUserChangePassword policy to the specified IAM group.

    Parameters:
        group_name (str): The name of the IAM group.
    """
    try:
        print(f"Attaching password change policy to group: {group_name}")
        iam.attach_group_policy(
            GroupName=group_name,
            PolicyArn=PASSWORD_CHANGE_POLICY_ARN
        )
    except botocore.exceptions.ClientError as e:
        print(f"Failed to attach policy to {group_name}: {e.response['Error']['Message']}")


def is_manual_group(group_name):
    """
    Determines whether an IAM group is likely manually created.

    Parameters:
        group_name (str): The name of the IAM group.

    Returns:
        bool: True if the group is likely manual; False if it's a system group.
    """
    if group_name.startswith("AWSReserved_") or group_name in EXCLUDED_GROUPS:
        return False
    return True


def main():
    """
    Main function to list IAM groups and attach the policy to applicable groups.
    """
    try:
        paginator = iam.get_paginator('list_groups')
        for page in paginator.paginate():
            for group in page['Groups']:
                group_name = group['GroupName']
                print(f"Found group: {group_name}")

                if is_manual_group(group_name):
                    attach_policy_to_group(group_name)
                else:
                    print(f"Skipping system-managed group: {group_name}")
    except botocore.exceptions.BotoCoreError as e:
        print(f"An error occurred: {str(e)}")


# Entry point
if __name__ == "__main__":
    # Initialize IAM client only once, at script entry
    iam = boto3.client('iam')
    main()
