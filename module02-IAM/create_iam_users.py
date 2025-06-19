#!/usr/bin/env python3

"""
create_iam_users.py

Reads user data from a CSV file and creates AWS IAM users accordingly.
Each user is added to a specified IAM group, assigned a login profile with
a default password, and forced to reset it on first login.

CSV Format:
firstName,lastName,awsGroup

Example:
John,Doe,Developers
Jane,Smith,Admins

Created in collaboration with OpenAI's ChatGPT (2025) for peer programming and educational use.
"""

import sys
import csv
import boto3
from botocore.exceptions import ClientError

# Import File
if len(sys.argv) < 2:
    print("Usage: python3 create_iam_users.py <csv_filename>")
    sys.exit(1)

CSV_FILENAME = sys.argv[1]

# Constants
DEFAULT_PASSWORD = "PasswordChange12345!"

# Initialize IAM client
iam = boto3.client('iam')

def create_iam_user(first_name, last_name, group_name):
    username = f"{first_name.lower()}.{last_name.lower()}"

    try:
        # Create IAM user
        print(f"Creating IAM user: {username}")
        iam.create_user(UserName=username)

        # Add user to specified group
        print(f"Adding user '{username}' to group '{group_name}'")
        iam.add_user_to_group(GroupName=group_name, UserName=username)

        # Create login profile
        print(f"Creating login profile for user '{username}'")
        iam.create_login_profile(
            UserName=username,
            Password=DEFAULT_PASSWORD,
            PasswordResetRequired=True
        )

        print(f"✅ User '{username}' created and configured successfully.\n")

    except ClientError as error:
        print(f"❌ Error creating user '{username}': {error.response['Error']['Message']}\n")

def main():
    try:
        with open(CSV_FILENAME, mode='r', newline='') as file:
            reader = csv.DictReader(file)
            for row in reader:
                first_name = row['firstName'].strip()
                last_name = row['lastName'].strip()
                group_name = row['awsGroup'].strip()
                create_iam_user(first_name, last_name, group_name)

    except FileNotFoundError:
        print(f"❌ CSV file '{CSV_FILENAME}' not found in the current directory.")
    except KeyError as e:
        print(f"❌ CSV is missing a required column: {e}")
    except Exception as e:
        print(f"❌ Unexpected error: {e}")

if __name__ == "__main__":
    main()
