 $ENV:ComputerAge = 90
$age = (get-date).AddDays(-$ENV:ComputerAge)
$DomainCheck = Get-CimInstance -ClassName Win32_OperatingSystem
New-Item -Path 'C:\TeamLogicIT' -ItemType Directory
if ($DomainCheck.ProductType -ne "2") { write-output "Invalid" | Out-File C:\TeamLogicIT\AD_Computer_List.txt ; exit 0 }
$OldComputers = Get-ADComputer -Filter * -properties cn,Enabled,LastLogonDate,Description | select Name,Enabled,LastLogonDate,Description | Where-Object {$_.LastLogonDate -lt $age -and $_.Enabled -eq "True"}


if (!$OldComputers) {
    write-output "No computers inactive for 90 days" | Out-File C:\TeamLogicIT\AD_Computer_List.txt
}
else {
    write-output "Please Review, computers inactive for 90+ days" @($OldComputers) | Out-File C:\TeamLogicIT\AD_Computer_List.txt
}
