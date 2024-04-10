$RemoteLocation = "\\172.16.171.85\userlog"
$LogFile = "$RemoteLocation\CorpIt_admin_log.csv"
$ComputerName = $env:COMPUTERNAME
$NewCorpitPassword = ConvertTo-SecureString -String "N9ghtm@r3" -AsPlainText -Force

try {
    $CorpitUser = Get-LocalUser -Name "corpit" -ErrorAction SilentlyContinue
    if ($CorpitUser) {
        Write-Output "The 'corpit' account already exists."

        # Change the password for the 'corpit' user
        $CorpitUser | Set-LocalUser -Password $NewCorpitPassword
        $LogEntry = [PSCustomObject]@{
            ComputerName = $ComputerName
            Action = "Changed password for 'corpit' user"
            Result = "Success"
        }
        $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation

        # Add 'corpit' user to Administrators group if not already a member
        if ($CorpitUser.LocalGroupMembership -notcontains "Administrators") {
            Write-Output "Adding 'corpit' user to the Administrators group."
            $CorpitUser | Add-LocalGroupMember -Group "Administrators"
            $LogEntry = [PSCustomObject]@{
                ComputerName = $ComputerName
                Action = "Added 'corpit' user to Administrators group"
                Result = "Success"
            }
            $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
        }
        else {
            Write-Output "The 'corpit' user is already a member of the Administrators group."
            $LogEntry = [PSCustomObject]@{
                ComputerName = $ComputerName
                Action = "Verified 'corpit' user is in Administrators group"
                Result = "Success"
            }
            $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
        }
    }
    else {
        Write-Output "The 'corpit' account does not exist. Creating it and adding to Administrators group."
        $NewCorpitUser = New-LocalUser -Name "corpit" -NoPassword
        $NewCorpitUser | Add-LocalGroupMember -Group "Administrators"
        $NewCorpitUser | Set-LocalUser -Password $NewCorpitPassword
        $LogEntry = [PSCustomObject]@{
            ComputerName = $ComputerName
            Action = "Created 'corpit' user and added to Administrators group"
            Result = "Success"
        }
        $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
    }

    # Disable the built-in Administrator account
    Write-Output "Disabling the Administrators account."
    Disable-LocalUser -Name "Administrator" -ErrorAction SilentlyContinue
    $LogEntry = [PSCustomObject]@{
        ComputerName = $ComputerName
        Action = "Disabled the Administrators account"
        Result = "Success"
    }
    $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
}
catch {
    $ErrorMessage = $_.Exception.Message
    $LogEntry = [PSCustomObject]@{
        ComputerName = $ComputerName
        Action = "Error occurred while processing script"
        Result = $ErrorMessage
    }
    $LogEntry | Export-Csv -Path $LogFile -Append -NoTypeInformation
}