# Scripts

The following scripts are used to manage user accounts and groups in a Windows environment.

## User_Account_Management.ps1

This script is designed to manage a specified user account on the local system. It performs the following tasks:

1. Checks if the specified user account exists, and if not, creates it.
2. Changes the password for the specified user account to a predefined value.
3. Adds the specified user to the Administrators group, if it's not already a member.
4. Disables the built-in Administrator account, if the specified user is a member of the Administrators group.
5. Logs all actions and their results to a CSV file located at the specified remote location.

### Usage

1. Update the `$RemoteLocation` variable with the appropriate network share path where the log file will be stored.
2. Update the `$User` variable with the name of the user account you want to manage.
3. Update the `$NewCorpitPassword` variable with the desired password for the specified user account.
4. Run the PowerShell script on the target system.

### Logging

The script logs all actions and their results to a CSV file named `User_Account_Management_Log.csv` in the specified `$RemoteLocation` directory. The log file contains the following information:

* `ComputerName`: The name of the computer where the script was executed.
* `Action`: The action performed by the script.
* `Result`: The outcome of the action (either "Success" or the error message).

### Disclaimer

This script is provided as-is, without any warranties or guarantees. It is the responsibility of the user to ensure that the script is used in a secure and appropriate manner, and that it does not cause any unintended consequences.


## mac_local_admin.sh

This script is used to manage local user accounts on MacOS systems. It performs the following tasks:

1. Checks if the specified user exists. If it doesn't exist, the script creates the user and adds it to the Admin group.
2. The script also logs the activity to a CSV file located at the specified network share.

### Usage

1. Update the `$RemoteLocation` variable with the appropriate network share path where the log file will be stored.
2. Update the `$User` variable with the name of the user account you want to manage.
3. Run the bash script on the target MacOS system.

### Logging

The script logs all actions and their results to a CSV file named `macos_user.csv` in the specified `$RemoteLocation` directory. The log file contains the following information:

* `Timestamp`: The date and time when the action was performed.
* `Hostname`: The name of the MacOS system where the script was executed.
* `Username`: The name of the user account that was acted upon.
* `Action`: The action performed by the script.

### Known Limitation 

- If the specified user account already exists and is not a member of the Admin group, the script will not be able to add the user to the Admin group.

### Disclaimer

This script is provided as-is, without any warranties or guarantees. It is the responsibility of the user to ensure that the script is used in a secure and appropriate manner, and that it does not cause any unintended consequences.

---


