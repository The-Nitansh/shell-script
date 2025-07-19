# Remote SSH Connection using Native Windows SSH via PowerShell
$remoteHost = "10.11.26.6"
$remotePort = 41116
$username = "npi-supple"
$password = 'NP!U$eS*PP#@035'

plink.exe -ssh $username@$remoteHost -P $remotePort -pw $password
