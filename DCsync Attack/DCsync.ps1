Import-Module ActiveDirectory
﻿$newstring = (Get-WmiObject -Class win32_computerSystem | select username).username
$CurrentUser = $newstring.Remove(0,9)
$domainDN = (Get-ADDomain).DistinguishedName
$acl = Get-ACL -Path "AD:\$domainDN"

$permissionGUIDs = @{
    #I Identified  the right GUIDS used in ACE by searching on https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/1522b774-6464-41a3-87a5-1e5633c3fbbb , 
    "Replicating Directory Changes" = '1131f6ad-9c07-11d1-f79f-00c04fc2dcd2'
    "Replicating Directory Changes All" = '89e95b76-444d-4c62-991a-0facbeda640c'
    #these are the ACR used in DCsync attack :)
}

$permissionResults = @{}

foreach ($ace in $acl.Access) {
    if ($ace.ActiveDirectoryRights -match "ExtendedRight" -and $ace.IsInherited -eq $false) {
        foreach ($permission in $permissionGUIDs.GetEnumerator()) {
            if ($ace.ObjectType -eq $permission.Value) {
                if (-not $permissionResults.ContainsKey($permission.Key)) {
                    $permissionResults[$permission.Key] = @()
                }
                $permissionResults[$permission.Key] += $ace.IdentityReference.Value
            }
        }
    }
}

$outputData = @()

foreach ($permission in $permissionGUIDs.GetEnumerator()) {
    foreach ($user in $permissionResults[$permission.Key]) {
        $outputData += [PSCustomObject]@{
            Permission = $permission.Key
            UserOrGroup = $user
        }
    }
}

$csvPath = "C:\Users\${CurrentUser}\Desktop\DCSync_Permissions.csv"
$outputData | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Exported to $csvPath"
