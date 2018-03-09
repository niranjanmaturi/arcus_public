# Arcus API Account

## What is a Arcus API Account
The Arcus API Account is used to authorize access to the Arcus web service (API). The credentials for the Arcus API account must be set in Cisco CloudCenter when configuring a call through Arcus to gather information from your infrastructure device.

## Arcus API Account Fields

**Descriptive Name**: The internal name for this Arcus API Account.

**Description**: The internal description for this Arcus API Account.

**Username**: The username for this account. Used to retrieve results from Arcus.

**Password**: The password for this account. Used to retrieve results from Arcus.

## Create a New Arcus API Account
1. Log in to Arcus
1. Choose **Arcus API Accounts** from the left navigation menu
1. Click the **New Arcus API Account** button
1. Enter a descriptive name for the account
1. Optionally, enter a longer description for the account
1. Enter a username
1. Enter a password and confirm the password
1. Click the **Create Arcus API Account** button

## Viewing all Arcus API Accounts
1. Choose **Arcus API Accounts** from the left navigation menu to view a list of all Arcus API Accounts

From this list of devices, you can view, edit, or remove existing Arcus API Accounts.

## Changing a Arcus API Account
1. Choose **Arcus API Accounts** from the left navigation menu
1. Click the **Edit** button matching the Arcus API Account you wish to change

You can change all of the information available for an API Account. **Note**: If you change the username or password for an API Account you will have to make matching changes to the automation you created using this account in Cisco CloudCenter.

## Removing a Arcus API Account
1. Choose **Arcus API Account** from the left navigation menu
1. Click the **Delete** button matching the API Account you wish to remove

(**Note**: Once removed, any automation in Cisco CloudCenter using this API Account will not be authorized to use the Arcus API and the only way to restore the API Account is to create it by following the instructions [Create a New Arcus API Account](#create-a-new-arcus-api-account))
