$tickets = klist
$lines = $tickets -split '\r\n'
$encryptionTypes = @()

foreach ($line in $lines) {
    if ($line -match 'Etype \(skey, tkt\)') {
        $encryptionTypes += ($line -split ':')[-1].Trim()
    }
}