$RemoteLocation = "\\192.168\userlog"
$LogFile = "$RemoteLocation\CorpIt_admin_log.csv"
$ComputerName = $env:COMPUTERNAME
$NewCorpitPassword = ConvertTo-SecureString -String "change_password" -AsPlainText -Force
$User = "corpit"

try {
    # Check if the '$User' account exists
    $UserAccount = Get-LocalUser -Name $User -ErrorAction SilentlyContinue
    if ($UserAccount) {
        Write-Output "The '$User' account already exists."

        # Change the password for the '$User' user
        $UserAccount | Set-LocalUser -Password $NewCorpitPassword
        $LogEntry = [PSCustomObject]@{
            ComputerName = $ComputerName
            Action = "Changed password for '$User' user"
            Result = "Success"
        }
        $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation

        # Check if the '$User' user is a member of the Administrators group
        $UserAdminMembership = (Get-LocalGroupMember -Group "Administrators").Name -like "*\" + $User
        if ($UserAdminMembership) {
            Write-Output "The '$User' user is already a member of the Administrators group."
        } else {
            Write-Output "Adding '$User' user to the Administrators group."
            $UserAccount | Add-LocalGroupMember -Group "Administrators"
            $LogEntry = [PSCustomObject]@{
                ComputerName = $ComputerName
                Action = "Added '$User' user to Administrators group"
                Result = "Success"
            }
            $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
        }
    } else {
        Write-Output "The '$User' account does not exist. Creating it and adding to Administrators group."
        $UserAccount = New-LocalUser -Name $User -NoPassword
        $UserAccount | Add-LocalGroupMember -Group "Administrators"
        $UserAccount | Set-LocalUser -Password $NewCorpitPassword
        $LogEntry = [PSCustomObject]@{
            ComputerName = $ComputerName
            Action = "Created '$User' user and added to Administrators group"
            Result = "Success"
        }
        $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
    }

    # Disable the built-in Administrator account
    $UserIsAdmin = (Get-LocalGroupMember -Group "Administrators").Name -like "*\" + $User
    if ($UserIsAdmin) {
        Write-Output "Disabling the Administrators account."
        Disable-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue
        $LogEntry = [PSCustomObject]@{
            ComputerName = $ComputerName
            Action = "Disabled the Administrators account"
            Result = "Success"
        }
        $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
    } else {
        Write-Output "'$User' user is not part of the Administrators group"
        $LogEntry = [PSCustomObject]@{
            ComputerName = $ComputerName
            Action = "Administrators account disable failed"
            Result = "Failed"
        }
        $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
    }
} catch {
    $ErrorMessage = $_.Exception.Message
    $LogEntry = [PSCustomObject]@{
        ComputerName = $ComputerName
        Action = "Error occurred while processing script"
        Result = $ErrorMessage
    }
    $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
}