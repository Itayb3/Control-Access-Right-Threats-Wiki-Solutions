import-module activedirectory

$root = [ADSI]"LDAP://RootDSE"
$domainpath = "AD:" + ($root.defaultnamingcontext).tostring()
$domaincontrollerpath = "AD:OU=Domain Controllers," + ($root.defaultnamingcontext).tostring()
[System.Collections.ArrayList]$pathstocheck = @()
[void]$pathstocheck.add($domainpath)
[void]$pathstocheck.add($domaincontrollerpath)

$extendedrightscheck = @(
    "1131f6ad-9c07-11d1-f79f-00c04fc2dcd2",
    "1131f6aa-9c07-11d1-f79f-00c04fc2dcd2",
    "89e95b76-444d-4c62-991a-0facbeda640c"
)
[System.Collections.ArrayList]$userswithextendedrights = @()
foreach ($pathtocheck in $pathstocheck) {
    $aces = (Get-Acl -Path $pathtocheck).Access | where { $.ObjectType -in $extendedrightscheck -and $.AccessControlType -eq "Allow" }
    foreach ($ace in $aces) {
        [void]$userswithextendedrights.add(($ace.IdentityReference).ToString())
    }
}

$userswithextendedrights = $userswithextendedrights | Select-Object -Unique

$userswithextendedrights

$userswithextendedrights | Format-Table | Out-File C:\tmp\DC_Sync_Users.csv

 

Write-Host "Users with specified extended rights exported to $csvFilePath"
