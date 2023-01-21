$JavaFolders = New-Object System.Collections.Generic.List[System.Object]

$JavaPath = "C:\Program Files\Java\"
if (Test-Path $JavaPath) {
    $JavaFolders.AddRange( (Get-ChildItem -Path "$JavaPath\jdk*" -Directory))
}

$JavaPath = "C:\Program Files (x86)\Java\"
if (Test-Path $JavaPath) {
    $JavaFolders.AddRange( (Get-ChildItem -Path "$JavaPath\jdk*" -Directory))
}

$JavaPath = "$env:USERPROFILE\.jdks\"
if (Test-Path $JavaPath) {
    $JavaFolders.AddRange( (Get-ChildItem -Path "$JavaPath\*jdk*" -Directory))
}

if (!$JavaFolders) {
    Write-Host "No java versions were found"
    Write-Host "Closing..." 
    Start-Sleep -Seconds 3
    exit
}

Write-Host "Installed java versions:"
$JavaFolders | ForEach-Object {Write-Host $_.FullName}
do {
    $JavaVersion = Read-Host "Enter the Java version you want to use (Ex: 16). Press 0 to exit"
    $JavaFolders = $JavaFolders | Where-Object {$_.Name -match "jdk-?$JavaVersion"}
    Write-Host "This Java version is not installed on your system, or I have not found it!"
    if ($JavaVersion.Equals('0')) {
        exit
    }

} while(!$JavaFolders)

$JavaHome = $JavaFolders[0].FullName
[Environment]::SetEnvironmentVariable("JAVA_HOME", $JavaHome, "User")

Write-Host "Your JAVA_HOME environment variable has been updated to $JavaHome "
Write-Host "Closing..." 
Start-Sleep -Seconds 3
exit