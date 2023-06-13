$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3.0

Write-Output "[INFO] Checking for Java..."
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Output "[ERROR] Java is not installed. Please install Java and try again."
    exit 1
} else {
    Write-Output "[INFO] Java is installed."
}

Write-Output "[INFO] Checking for server plugin dependencies..."
if (!(Test-Path -Path "plugins\ProtocolLib*.jar")) {
    Write-Error "[ERROR] ProtocolLib is not installed. Please install ProtocolLib and try again."
}
if (!(Test-Path -Path "plugins\LibsDisguises*.jar")) {
    Write-Error "[ERROR] LibsDisguises is not installed. Please install LibsDisguises and try again."
}
if (!(Test-Path -Path "plugins\MythicMobs*.jar")) {
    Write-Error "[ERROR] MythicMobs is not installed. Please install MythicMobs and try again."
}
Write-Output "[INFO] All server plugin dependencies are installed."

Write-Output "[INFO] Checking for server.properties file..."
if (!(Test-Path -Path "server.properties")) {
    Write-Warning "[WARNING] server.properties file not found. The server will generate a new one."
} else {
    Write-Output "[INFO] server.properties file found."
}

Write-Output "[INFO] Collecting server .jar file..."
$jarFile = Get-ChildItem -Filter "purpur*.jar" | Select-Object -First 1
Write-Output "[INFO] Using '$jarFile' as the server .jar file."


Write-Output "Please enter the desired RAM amount in gigabytes (Leave empty for 8): "
$ram = Read-Host
# Test if RAM is an integer
if ($ram -match "[^0-9]") {
    Write-Error "[ERROR] RAM must be an integer."
    exit 1
}

if ($ram -eq "") {
    $ram = 8
}
Write-Output "[INFO] Starting server with $ram GB of RAM..."

$javaArgs = @("-Xms${ram}G", "-Xmx${ram}G", "-XX:+UseG1GC", "-XX:+ParallelRefProcEnabled", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+DisableExplicitGC", "-XX:+AlwaysPreTouch", "-XX:G1NewSizePercent=30", "-XX:G1MaxNewSizePercent=40", "-XX:G1HeapRegionSize=8M", "-XX:G1ReservePercent=20", "-XX:G1HeapWastePercent=5", "-XX:G1MixedGCCountTarget=4", "-XX:InitiatingHeapOccupancyPercent=15", "-XX:G1MixedGCLiveThresholdPercent=90", "-XX:G1RSetUpdatingPauseTimePercent=5", "-XX:SurvivorRatio=32", "-XX:+PerfDisableSharedMem", "-XX:MaxTenuringThreshold=1", "-Dusing.aikars.flags=https://mcflags.emc.gs", "-Daikars.new.flags=true", "-jar", "${jarFile}", "nogui")
java $javaArgs