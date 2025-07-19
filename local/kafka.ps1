param(
    [Parameter(Mandatory=$false, HelpMessage="Start Kafka and Zookeeper")]
    [switch] $start,

    [Parameter(Mandatory=$false, HelpMessage="Stop Kafka and Zookeeper")]
    [switch] $stop,

    [Parameter(Mandatory=$false, HelpMessage="Kill the java.exe task")]
    [switch] $kill,

    [Parameter(Mandatory=$false, HelpMessage="Clean the zookeeper and kafka server directory")]
    [switch] $clean,

    [Parameter(Mandatory=$false, HelpMessage="Show process IDs")]
    [switch] $i,

    [Parameter(Mandatory=$false, HelpMessage="Do not hide the window")]
    [switch] $f
)

. ..\path.ps1

<# $basePath = "C:\Apps\kafka"

$zookeeper = @{
    "start" = ".\bin\windows\zookeeper-server-start.bat"
    "stop" = ".\bin\windows\zookeeper-server-stop.bat"
    "config" = ".\config\zookeeper.properties"
    "service" = "zookeeper"
}

$kafka = @{
    "start" = ".\bin\windows\kafka-server-start.bat"
    "stop" = ".\bin\windows\kafka-server-stop.bat"
    "config" = ".\config\server.properties"
    "service" = "kafka.Kafka"
}
 #>
function Initialize()
{
    # ZooKeeper
    $zkCommand = "cd `"$basePath`"; $($zookeeper.start) $($zookeeper.config)"
    Write-Output "Starting ZooKeeper..."

    switch($f.IsPresent)
    {
        $true { Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", $zkCommand }
        $false { Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", $zkCommand -WindowStyle Hidden }
    }
    
    Start-Sleep -Seconds 10
    Write-Output "...Started Zookeeper"
    Start-Sleep -Seconds 10

    # Kafka
    $kafkaCommand = "cd `"$basePath`"; $($kafka.start) $($kafka.config)"
    Write-Output "Starting Kafka Server..."

    switch($f.IsPresent)
    {
        $true { Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", $kafkaCommand }
        $false { Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", $kafkaCommand -WindowStyle Hidden }
    }
    Write-Output "...Started Kafka Server"
    GetPID -pattern "kafka"
}

function Terminate
{
    # Kafka
    $kafkaCommand = "cd `"$basePath`"; $($kafka.stop)"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", $kafkaCommand    
    Start-Sleep -Seconds 5
    Write-Output "...Terminated Kafka Server Instance"

    # ZooKeeper
    $zkCommand = "cd `"$basePath`"; $($zookeeper.stop)"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", $zkCommand
    Start-Sleep -Seconds 5
    Write-Output "...Terminated Kafka ZooKeeper Instance"
}

function GetPID()
{
    param(
        [string] $pattern
    )

    Get-WmiObject Win32_Process |
    Where-Object {
        $_.CommandLine -like "*$pattern*"
    } |
    Select-Object ProcessId, CommandLine |
    Format-Table -AutoSize
}

if($kill.IsPresent)
{
    $command = "takskill /F /IM java.exe"
    Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", "`"$command`""
}

if($clean.IsPresent)
{
    $path = "$basePath\logs\*"
    powershell Remove-Item -Path "`"$filePath`"" -Recurse -Force
}


if ($i.IsPresent)
{
    # Use a pattern that matches the actual command line, e.g., the service or script name
    GetPID -pattern "zookeeper"
    GetPID -pattern "kafka"
}
elseif ($start.IsPresent -and -not $stop.IsPresent)
{
    Initialize
}
elseif ($stop.IsPresent -and -not $start.IsPresent)
{
    Terminate
}
else
{
    Write-Output "Please specify either -start or -stop (but not both)."
}