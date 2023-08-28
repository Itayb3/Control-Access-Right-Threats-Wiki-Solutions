Import-Module ActiveDirectory
$results = @()
Get-ADUser -Filter {ServicePrincipalName -like "*"} -Property ServicePrincipalName | ForEach-Object {
    foreach ($spn in $_.ServicePrincipalName) {
        $results += [PSCustomObject]@{
            'Type'  = 'User'
            'Name'  = $_.Name
            'SPN'   = $spn
        }
    }
}

Get-ADComputer -Filter {ServicePrincipalName -like "*"} -Property ServicePrincipalName | ForEach-Object {
    foreach ($spn in $_.ServicePrincipalName) {
        $results += [PSCustomObject]@{
            'Type'  = 'Computer'
            'Name'  = $_.Name
            'SPN'   = $spn
        }
    }
}


$results | Export-Csv -Path "SPNs.csv" -NoTypeInformation

Write-Host "Export completed. Check SPNs.csv for the list of SPNs."
