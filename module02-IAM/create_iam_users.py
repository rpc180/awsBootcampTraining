#!/usr/bin/env python3

"""
create_iam_users.py

Reads a CSV file of IAM users and creates them in AWS, with support for:
  • Unicode normalization & accent-stripping (e.g., "quitéria.xavier" → "quiteria.xavier")
  • Validation & removal of invalid IAM username characters

Usage:
  python create_iam_users.py path/to/users.csv

CSV format:
  firstName,lastName,awsGroup
  John,Doe,Developers
  xavier,quitéria,networkAdmins

Requirements:
  Python 3.6+
  boto3
  Standard library modules: csv, unicodedata, re

Workflow:
  1. Reads and parses the CSV input
  2. Normalizes and sanitizes usernames for IAM compliance
  3. Creates IAM users and assigns them to specified AWS groups via the Boto3 client

Examples:
  normalize_username('cauã.setúbal') → 'caua.setubal'

License:
  This script is distributed under the terms of the GNU General Public License v3.0.
  You are free to use, modify, and redistribute it under the same license.

Attribution:
  Created in collaboration with OpenAI's ChatGPT (2025) as part of a peer programming 
  and educational exercise to enhance automation workflows in AWS IAM.
  
"""

import sys
import csv
import unicodedata
import re
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

def normalize_username(name):
    # Normalize the string to NFKD form
    nfkd_form = unicodedata.normalize('NFKD', name)
    
    # Remove accents by discarding 'combining' characters
    no_accents = ''.join([c for c in nfkd_form if not unicodedata.combining(c)])
    
    # Remove any characters not allowed in IAM usernames
    return re.sub(r'[^a-zA-Z0-9+=,.@_-]', '', no_accents)

def create_iam_user(first_name, last_name, group_name):
    username = normalize_username(f"{first_name.lower()}.{last_name.lower()}")

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
