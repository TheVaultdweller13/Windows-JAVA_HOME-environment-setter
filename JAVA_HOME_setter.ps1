$JavaFolders = New-Object System.Collections.Generic.List[System.Object]

$JavaPaths = @(
    "C:\Program Files\Java\",
    "C:\Program Files (x86)\Java\",
    "$env:USERPROFILE\.jdks\")

foreach($JavaPath In $JavaPaths) {
    if (Test-Path $JavaPath) {
        $JavaFolders.AddRange((Get-ChildItem -Path "$JavaPath\jdk*" -Directory))
    }
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

    if ($JavaVersion.Equals('0')) {
        exit
    }

    if (!$JavaFolders) {
        Write-Host "This Java version is not installed on your system, or I have not found it!"
    }

} while(!$JavaFolders)

$JavaHome = $JavaFolders[0].FullName
[Environment]::SetEnvironmentVariable("JAVA_HOME", $JavaHome, "User")

Write-Host "Script has finished, JAVA_HOME has been set to $JavaHome"
Write-Host "Closing..." 
Start-Sleep -Seconds 5
exit