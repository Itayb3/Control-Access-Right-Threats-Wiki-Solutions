Import-Module ActiveDirectory

$domainDN = (Get-ADDomain).DistinguishedName
$acl = Get-ACL -Path "AD:\$domainDN"

$permissionGUIDs = @{
    "Replicating Directory Changes" = '1131f6ad-9c07-11d1-f79f-00c04fc2dcd2'
    "Replicating Directory Changes All" = '89e95b76-444d-4c62-991a-0facbeda640c'
    "Replication Get-Changes In Filtered Set" = '89e95b76-444d-4c62-991a-0facbeda640c'
}

$permissionResults = @{}

foreach ($ace in $acl.Access) {
    if ($ace.ActiveDirectoryRights -match "ExtendedRight") {
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

$csvPath = "$([Environment]::GetFolderPath('Desktop'))\DCSync_Permissions.csv"
$outputData | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Exported to $csvPath"
