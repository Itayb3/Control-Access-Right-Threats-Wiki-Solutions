Import-Module ActiveDirectory

# Guids came from - https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/1522b774-6464-41a3-87a5-1e5633c3fbbb
$permissions = @(
    "1131f6ad-9c07-11d1-f79f-00c04fc2dcd2",   # Replicating Directory Changes GUID
    "1131f6aa-9c07-11d1-f79f-00c04fc2dcd2"    # Replicating Directory Changes All GUID
)

$results = @()

foreach ($perm in $permissions) {
    $results += Get-ADObject -Filter * -Property ntSecurityDescriptor | Where-Object {
        ($_.ntSecurityDescriptor.Access | Where-Object {
            $_.ObjectType -eq $perm
        }) -ne $null
    } | Select-Object DistinguishedName, Name, ObjectClass
}

$domainAdmins = Get-ADGroupMember -Identity "Domain Admins"
foreach ($admin in $domainAdmins) {
    $results += [PSCustomObject]@{
        DistinguishedName = $admin.DistinguishedName
        Name = $admin.Name
        ObjectClass = $admin.objectClass
    }
}

$results = $results | Sort-Object DistinguishedName -Unique

$results | Export-Csv -Path 'add path here' -NoTypeInformation


