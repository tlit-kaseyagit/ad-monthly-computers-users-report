 $ENV:UserAge = 30

$age = (get-date).AddDays(-$ENV:UserAge)

$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem

if ($DomainCheck.ProductType -ne "2") { write-output "Invalid" | Out-File C:\TeamLogicIT\AD_User_List.txt ; exit 0 }

$OldUsers = Get-ADuser -Filter * -properties Name, Enabled, LastLogonDate, Description | select Name, Enabled, LastLogonDate, Description | Where-Object { $_.LastLogonDate -lt $age -and $_.Enabled -eq "True"}





if (!$OldUsers) {

    write-output "No users inactive for 30 days" | Out-File C:\TeamLogicIT\AD_User_List.txt

}

else {

       
    write-output "Please Review, users inactive for 30+ days" @($OldUsers) | Out-File C:\TeamLogicIT\AD_User_List.txt

} 
