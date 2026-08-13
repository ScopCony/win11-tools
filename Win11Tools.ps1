# =====================================================================
#  WIN 11 TOOLS - by ScopCony
#  Optymalizacja Windows 11 (Enterprise LTSC / Pro)
#  Uruchomienie:
#  irm ('https://raw.githubusercontent.com/ScopCony/win11-tools/main/Win11Tools.ps1?cache=' + (Get-Date).Ticks) | iex
# =====================================================================

# region Konfiguracja repo (auto-elewacja + pobieranie apps.json)
$script:RepoUrl  = 'https://raw.githubusercontent.com/ScopCony/win11-tools/main'
$script:SelfUrl  = "$($script:RepoUrl)/Win11Tools.ps1"
# endregion

# region Konfiguracja protokolu sieciowego
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
# endregion

# region AUTO-ELEWACJA DO ADMINA
# Przy uruchomieniu przez irm|iex nie ma pliku na dysku, wiec ponownie
# pobieramy skrypt w nowym oknie PowerShell z uprawnieniami administratora.
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host ""
    Write-Host "  Skrypt wymaga uprawnien administratora." -ForegroundColor Yellow
    Write-Host "  Uruchamiam ponownie w nowym oknie jako administrator..." -ForegroundColor Cyan
    Write-Host ""

    $relaunchCmd = "irm ('$($script:SelfUrl)?cache=' + (Get-Date).Ticks) | iex"
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($relaunchCmd))

    try {
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-EncodedCommand", $encoded
        Write-Host "  Nowe okno otwarte. Mozesz zamknac to okno." -ForegroundColor Green
    }
    catch {
        Write-Host "  Nie udalo sie podniesc uprawnien: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "  Uruchom PowerShell jako administrator i sprobuj ponownie." -ForegroundColor Red
    }
    return
}
# endregion

# region Wymuszenie kodowania
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
# endregion

# region Definicje kolorow
$colors = @{
    Error       = "Red"
    Success     = "Green"
    Highlight   = "Blue"
    Header      = "DarkRed"
    Info        = "White"
    DefaultText = "Gray"
    Warning     = "Yellow"
}
# endregion

# region LOGO

function Convert-ToAsciiArt {
    param([string]$Text)

    $Text = $Text.ToUpper()
    $lines = @("", "", "", "", "", "")

    foreach ($char in $Text.ToCharArray()) {
        switch ($char) {
            'W' {
                $lines[0] += "██╗    ██╗"
                $lines[1] += "██║    ██║"
                $lines[2] += "██║ █╗ ██║"
                $lines[3] += "██║███╗██║"
                $lines[4] += "╚███╔███╔╝"
                $lines[5] += " ╚══╝╚══╝ "
            }
            'I' {
                $lines[0] += "██╗ "
                $lines[1] += "██║ "
                $lines[2] += "██║ "
                $lines[3] += "██║ "
                $lines[4] += "██║ "
                $lines[5] += "╚═╝ "
            }
            '1' {
                $lines[0] += " ██╗ "
                $lines[1] += "███║ "
                $lines[2] += "╚██║ "
                $lines[3] += " ██║ "
                $lines[4] += " ██║ "
                $lines[5] += " ╚═╝ "
            }
            'L' {
                $lines[0] += "██╗       "
                $lines[1] += "██║       "
                $lines[2] += "██║       "
                $lines[3] += "██║       "
                $lines[4] += "███████╗  "
                $lines[5] += "╚══════╝  "
            }
            'T' {
                $lines[0] += "████████╗ "
                $lines[1] += "╚══██╔══╝ "
                $lines[2] += "   ██║    "
                $lines[3] += "   ██║    "
                $lines[4] += "   ██║    "
                $lines[5] += "   ╚═╝    "
            }
            'S' {
                $lines[0] += "███████╗  "
                $lines[1] += "██╔════╝  "
                $lines[2] += "███████╗  "
                $lines[3] += "╚════██║  "
                $lines[4] += "███████║  "
                $lines[5] += "╚══════╝  "
            }
            'C' {
                $lines[0] += " ██████╗  "
                $lines[1] += "██╔════╝  "
                $lines[2] += "██║       "
                $lines[3] += "██║       "
                $lines[4] += "╚██████╗  "
                $lines[5] += " ╚═════╝  "
            }
            'O' {
                $lines[0] += " ██████╗  "
                $lines[1] += "██╔═══██╗ "
                $lines[2] += "██║   ██║ "
                $lines[3] += "██║   ██║ "
                $lines[4] += "╚██████╔╝ "
                $lines[5] += " ╚═════╝  "
            }
            'B' {
                $lines[0] += "██████╗   "
                $lines[1] += "██╔══██╗  "
                $lines[2] += "██████╔╝  "
                $lines[3] += "██╔══██╗  "
                $lines[4] += "██████╔╝  "
                $lines[5] += "╚═════╝   "
            }
            'Y' {
                $lines[0] += "██╗   ██╗ "
                $lines[1] += "╚██╗ ██╔╝ "
                $lines[2] += " ╚████╔╝  "
                $lines[3] += "  ╚██╔╝   "
                $lines[4] += "   ██║    "
                $lines[5] += "   ╚═╝    "
            }
            'P' {
                $lines[0] += "██████╗   "
                $lines[1] += "██╔══██╗  "
                $lines[2] += "██████╔╝  "
                $lines[3] += "██╔═══╝   "
                $lines[4] += "██║       "
                $lines[5] += "╚═╝       "
            }
            'N' {
                $lines[0] += "███╗   ██╗"
                $lines[1] += "████╗  ██║"
                $lines[2] += "██╔██╗ ██║"
                $lines[3] += "██║╚██╗██║"
                $lines[4] += "██║ ╚████║"
                $lines[5] += "╚═╝  ╚═══╝"
            }
            ' ' {
                $lines[0] += "    "
                $lines[1] += "    "
                $lines[2] += "    "
                $lines[3] += "    "
                $lines[4] += "    "
                $lines[5] += "    "
            }
            default {
                $lines[0] += "████ "
                $lines[1] += "████ "
                $lines[2] += "████ "
                $lines[3] += "████ "
                $lines[4] += "████ "
                $lines[5] += "████ "
            }
        }
    }

    return $lines
}

function Show-SunsetLogo {
    param([string]$Text)

    $sunsetColors = @('Red', 'Red', 'Red', 'DarkRed', 'DarkRed')
    $asciiLines = Convert-ToAsciiArt $Text

    for ($i = 0; $i -lt $asciiLines.Count; $i++) {
        $colorIndex = $i % $sunsetColors.Count
        Write-Host $asciiLines[$i] -ForegroundColor $sunsetColors[$colorIndex]
    }
    Write-Host ""
}

Clear-Host

try {
    $loadingChars = @('⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏')
    Write-Host "  Tworzenie logo " -ForegroundColor Yellow -NoNewline
    for ($i = 0; $i -lt 3; $i++) {
        Write-Host $loadingChars[$i] -ForegroundColor Cyan -NoNewline
        Start-Sleep -Milliseconds 150
        Write-Host "`b" -NoNewline
    }
    Write-Host "✓" -ForegroundColor Green
    Write-Host ""

    Show-SunsetLogo "WIN 11 TOOL"
    Show-SunsetLogo "BY SCOPCONY"

    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor DarkMagenta
    Write-Host "║                                                                ║" -ForegroundColor DarkMagenta
    Write-Host "║                     === SUNSET EDITION ===                     ║" -ForegroundColor Yellow
    Write-Host "║                                                                ║" -ForegroundColor DarkMagenta
    Write-Host "║             Windows 11 Optimization & Debloat Tool             ║" -ForegroundColor White
    Write-Host "║                                                                ║" -ForegroundColor DarkMagenta
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkMagenta
}
catch {
    Write-Host ""
    Write-Host "  ██╗    ██╗██╗███╗   ██╗     ██╗ ██╗    ████████╗ ██████╗  ██████╗ ██╗     " -ForegroundColor Magenta
    Write-Host "  ██║    ██║██║████╗  ██║    ███║███║    ╚══██╔══╝██╔═══██╗██╔═══██╗██║     " -ForegroundColor Red
    Write-Host "  ██║ █╗ ██║██║██╔██╗ ██║    ╚██║╚██║       ██║   ██║   ██║██║   ██║██║     " -ForegroundColor DarkRed
    Write-Host "  ██║███╗██║██║██║╚██╗██║     ██║ ██║       ██║   ██║   ██║██║   ██║██║     " -ForegroundColor Yellow
    Write-Host "  ╚███╔███╔╝██║██║ ╚████║     ██║ ██║       ██║   ╚██████╔╝╚██████╔╝███████╗" -ForegroundColor DarkYellow
    Write-Host "   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝     ╚═╝ ╚═╝       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝" -ForegroundColor White
}

Write-Host ""
Write-Host "                    by ScopCony 2026 $([char]0x00A9)                       " -ForegroundColor DarkCyan
Write-Host ""

# endregion

# region DASHBOARD

$currentUser = [Environment]::UserName + "@" + [Environment]::MachineName
$operatingSystem = (Get-CimInstance Win32_OperatingSystem).Caption
$currentTime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
$powerShellVersion = $PSVersionTable.PSVersion.Major.ToString() + "." + $PSVersionTable.PSVersion.Minor.ToString()

$processorInfo = (Get-CimInstance Win32_Processor).Name
$videoCard = (Get-CimInstance Win32_VideoController | Where-Object {$_.Name -notlike "*Basic*"}).Name | Select-Object -First 1
$networkAdapter = (Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$null -ne $_.IPAddress}).IPAddress[0]

# Get-Counter uzywa nazw licznikow zaleznych od jezyka systemu i wysypuje sie
# na zlokalizowanych/uszkodzonych licznikach - CIM dziala niezaleznie od jezyka.
$cpuLoad = "n/a"
try {
    $loadValues = (Get-CimInstance Win32_Processor -ErrorAction Stop).LoadPercentage
    if ($null -ne $loadValues) {
        $cpuLoad = [math]::Round(($loadValues | Measure-Object -Average).Average, 1)
    }
}
catch {
    $cpuLoad = "n/a"
}

$ramInfo = Get-CimInstance Win32_ComputerSystem
$totalRAM = [math]::Round($ramInfo.TotalPhysicalMemory / 1GB, 1)
$osInfo = Get-CimInstance Win32_OperatingSystem
$freeRAM = [math]::Round($osInfo.FreePhysicalMemory / 1MB, 1)
$usedRAM = [math]::Round($totalRAM - $freeRAM, 1)

$diskList = Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}

function Format-TableLine {
    param([string]$text, [int]$width = 48)
    while ($text.Length -lt $width) { $text += " " }
    return $text
}

Write-Host "+===============[ OVERVIEW ]================+" -ForegroundColor Cyan

Write-Host (Format-TableLine ("| User: " + $currentUser)) -NoNewline
Write-Host "|"
Write-Host (Format-TableLine ("| System: " + $operatingSystem)) -NoNewline
Write-Host "|"
Write-Host (Format-TableLine ("| Date: " + $currentTime)) -NoNewline
Write-Host "|"
Write-Host (Format-TableLine ("| PowerShell: " + $powerShellVersion)) -NoNewline
Write-Host "|"

Write-Host "+==============[ HARDWARE ]================+" -ForegroundColor Cyan

$cpuLine = "| Processor: " + $processorInfo.Substring(0, [Math]::Min(25, $processorInfo.Length))
Write-Host (Format-TableLine $cpuLine) -NoNewline
Write-Host "|"

$cpuUsageLine = "| CPU Usage: " + $cpuLoad + "%"
if ($cpuLoad -isnot [double] -and $cpuLoad -isnot [int]) {
    $cpuUsageLine = "| CPU Usage: brak odczytu"
    Write-Host (Format-TableLine $cpuUsageLine) -NoNewline -ForegroundColor DarkGray
} elseif ($cpuLoad -gt 80) {
    Write-Host (Format-TableLine $cpuUsageLine) -NoNewline -ForegroundColor Red
} elseif ($cpuLoad -gt 60) {
    Write-Host (Format-TableLine $cpuUsageLine) -NoNewline -ForegroundColor Yellow
} else {
    Write-Host (Format-TableLine $cpuUsageLine) -NoNewline -ForegroundColor Green
}
Write-Host "|"

if ($videoCard) {
    $gpuLine = "| Graphics: " + $videoCard.Substring(0, [Math]::Min(25, $videoCard.Length))
    Write-Host (Format-TableLine $gpuLine) -NoNewline
    Write-Host "|"
}

$memoryLine = "| RAM: " + $usedRAM + "GB / " + $totalRAM + "GB"
Write-Host (Format-TableLine $memoryLine) -NoNewline -ForegroundColor Green
Write-Host "|"

Write-Host "+===============[ NETWORK ]================+" -ForegroundColor Cyan

Write-Host (Format-TableLine ("| IP Address: " + $networkAdapter)) -NoNewline
Write-Host "|"

Write-Host "+==============[ STORAGE ]================+" -ForegroundColor Cyan

foreach ($disk in $diskList) {
    $totalSize = [math]::Round($disk.Size / 1GB, 0)
    $freeSpace = [math]::Round($disk.FreeSpace / 1GB, 0)
    $usedSpace = $totalSize - $freeSpace
    $diskPercent = [math]::Round(($usedSpace / $totalSize) * 100, 1)

    $diskColor = "Green"
    $diskStatus = ""
    if ($diskPercent -ge 90) {
        $diskColor = "Red"
        $diskStatus = " [CRITICAL]"
    }
    elseif ($diskPercent -ge 75) {
        $diskColor = "Yellow"
        $diskStatus = " [WARNING]"
    }

    $diskLine = "| Drive " + $disk.DeviceID + " " + $usedSpace + "GB / " + $totalSize + "GB (" + $diskPercent + "%)" + $diskStatus
    Write-Host (Format-TableLine $diskLine) -NoNewline -ForegroundColor $diskColor
    Write-Host "|"
}

Write-Host "+==========================================+" -ForegroundColor Cyan
Write-Host ""

# endregion

# region FUNKCJE POMOCNICZE

function New-SystemRestorePoint {
    Write-Host "`nTworze punkt przywracania systemu..." -ForegroundColor $colors.Info
    try {
        Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "Win 11 Tools - przed optymalizacja" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-Host "Punkt przywracania utworzony pomyslnie." -ForegroundColor $colors.Success
    }
    catch {
        Write-Host "Nie udalo sie utworzyc punktu przywracania: $($_.Exception.Message)" -ForegroundColor $colors.Warning
        Write-Host "(Na LTSC ochrona systemu bywa domyslnie wylaczona)" -ForegroundColor $colors.DefaultText
    }
}

function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        $Value,
        [string]$Type = "DWord"
    )
    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -ErrorAction Stop
        return $true
    }
    catch {
        Write-Host "  Blad rejestru ($Path\$Name): $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $false
    }
}

# endregion

# region MODULY OPTYMALIZACJI

$servicesToDisable = @(
    @{ Name = "WSearch";          Desc = "Windows Search - masz Everything" },
    @{ Name = "Spooler";          Desc = "Print Spooler - brak drukarki" },
    @{ Name = "bthserv";          Desc = "Bluetooth Support" },
    @{ Name = "BthAvctpSvc";      Desc = "Bluetooth AVCTP" },
    @{ Name = "XblAuthManager";   Desc = "Xbox Live Auth" },
    @{ Name = "XblGameSave";      Desc = "Xbox Live Game Save" },
    @{ Name = "XboxNetApiSvc";    Desc = "Xbox Live Networking" },
    @{ Name = "XboxGipSvc";       Desc = "Xbox Accessory Management" },
    @{ Name = "DiagTrack";        Desc = "Telemetria - Connected User Experiences" },
    @{ Name = "dmwappushservice"; Desc = "WAP Push (telemetria)" },
    @{ Name = "MapsBroker";       Desc = "Downloaded Maps Manager" },
    @{ Name = "RetailDemo";       Desc = "Retail Demo Service" },
    @{ Name = "Fax";              Desc = "Fax" },
    @{ Name = "SysMain";          Desc = "Superfetch - system na SSD" },
    @{ Name = "RemoteRegistry";   Desc = "Remote Registry - ryzyko bezpieczenstwa" },
    @{ Name = "WalletService";    Desc = "Portfel / NFC" },
    @{ Name = "PhoneSvc";         Desc = "Phone Service" },
    @{ Name = "SEMgrSvc";         Desc = "Payments and NFC/SE Manager" },
    @{ Name = "AJRouter";         Desc = "AllJoyn Router (IoT)" },
    @{ Name = "WwanSvc";          Desc = "WWAN AutoConfig - brak modemu" },
    @{ Name = "MessagingService"; Desc = "Messaging Service" },
    @{ Name = "PcaSvc";           Desc = "Program Compatibility Assistant" }
)

function Invoke-DisableServices {
    Write-Host "`n==== Wylaczanie zbednych uslug ====`n" -ForegroundColor $colors.Header

    $okCount = 0
    foreach ($svc in $servicesToDisable) {
        $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
        if ($service) {
            try {
                Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
                Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction Stop
                Write-Host ("  [OK]      {0,-20} - {1}" -f $svc.Name, $svc.Desc) -ForegroundColor $colors.Success
                $okCount++
            }
            catch {
                Write-Host ("  [BLAD]    {0,-20} - {1}" -f $svc.Name, $_.Exception.Message) -ForegroundColor $colors.Error
            }
        }
        else {
            Write-Host ("  [POMIN]   {0,-20} - nie znaleziono" -f $svc.Name) -ForegroundColor $colors.DefaultText
        }
    }

    # RDP - blokujemy polaczenia, ale NIE wylaczamy uslugi (Fast User Switching itp.)
    Write-Host "`n  Blokowanie polaczen RDP (usluga zostaje na Manual)..." -ForegroundColor $colors.Info
    if (Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 1) {
        Set-Service -Name "TermService" -StartupType Manual -ErrorAction SilentlyContinue
        Write-Host "  [OK]      Polaczenia RDP zablokowane" -ForegroundColor $colors.Success
    }

    Write-Host "`nWylaczono uslug: $okCount / $($servicesToDisable.Count)" -ForegroundColor $colors.Highlight
    Write-Host "UWAGA: kamera i biometria (WbioSrvc) celowo NIE sa ruszane." -ForegroundColor $colors.DefaultText
}

function Invoke-TelemetryTweaks {
    Write-Host "`n==== Telemetria i prywatnosc ====`n" -ForegroundColor $colors.Header

    Write-Host "  Ustawienia rejestru..." -ForegroundColor $colors.Info
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 | Out-Null
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 | Out-Null
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Value 1 | Out-Null
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 | Out-Null
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Value 0 | Out-Null
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 | Out-Null
    Write-Host "  [OK]      Telemetria wylaczona w rejestrze" -ForegroundColor $colors.Success

    Write-Host "`n  Wylaczanie zadan telemetrycznych..." -ForegroundColor $colors.Info
    $tasksToDisable = @(
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Autochk\Proxy",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
        "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask",
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
        "\Microsoft\Windows\Feedback\Siuf\DmClient",
        "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
    )

    foreach ($task in $tasksToDisable) {
        $taskName = Split-Path $task -Leaf
        $taskPath = (Split-Path $task -Parent) + "\"
        try {
            Disable-ScheduledTask -TaskPath $taskPath -TaskName $taskName -ErrorAction Stop | Out-Null
            Write-Host ("  [OK]      {0}" -f $taskName) -ForegroundColor $colors.Success
        }
        catch {
            Write-Host ("  [POMIN]   {0}" -f $taskName) -ForegroundColor $colors.DefaultText
        }
    }
}

function Invoke-RemoveBloatware {
    Write-Host "`n==== Usuwanie UWP bloatware ====`n" -ForegroundColor $colors.Header

    $uwpApps = @(
        @{ Pattern = "*Microsoft.YourPhone*";                     Desc = "Phone Link" },
        @{ Pattern = "*Microsoft.SkypeApp*";                      Desc = "Skype" },
        @{ Pattern = "*Microsoft.MixedReality.Portal*";           Desc = "Mixed Reality Portal" },
        @{ Pattern = "*Microsoft.GetHelp*";                       Desc = "Get Help" },
        @{ Pattern = "*Microsoft.WindowsFeedbackHub*";            Desc = "Feedback Hub" },
        @{ Pattern = "*Microsoft.Getstarted*";                    Desc = "Tips" },
        @{ Pattern = "*Clipchamp.Clipchamp*";                     Desc = "Clipchamp" },
        @{ Pattern = "*Microsoft.MicrosoftSolitaireCollection*";  Desc = "Solitaire" },
        @{ Pattern = "*Microsoft.BingNews*";                      Desc = "News" },
        @{ Pattern = "*Microsoft.BingWeather*";                   Desc = "Weather" },
        @{ Pattern = "*Microsoft.MicrosoftOfficeHub*";            Desc = "Office Hub" },
        @{ Pattern = "*Microsoft.People*";                        Desc = "People" },
        @{ Pattern = "*Microsoft.Microsoft3DViewer*";             Desc = "3D Viewer" },
        @{ Pattern = "*Microsoft.MSPaint*";                       Desc = "Paint 3D" },
        @{ Pattern = "*Microsoft.WindowsAlarms*";                 Desc = "Alarms and Clock" },
        @{ Pattern = "*MicrosoftTeams*";                          Desc = "Teams (consumer)" }
    )

    foreach ($app in $uwpApps) {
        $pkg = Get-AppxPackage -Name $app.Pattern -AllUsers -ErrorAction SilentlyContinue
        if ($pkg) {
            $pkg | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
            Write-Host ("  [OK]      {0}" -f $app.Desc) -ForegroundColor $colors.Success
        }
        else {
            Write-Host ("  [POMIN]   {0} - nie znaleziono" -f $app.Desc) -ForegroundColor $colors.DefaultText
        }

        $provPkg = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.PackageName -like $app.Pattern }
        if ($provPkg) {
            $provPkg | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
        }
    }

    Write-Host "`n  Usuwanie OneDrive..." -ForegroundColor $colors.Info
    Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    $oneDriveSetup = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
    if (-not (Test-Path $oneDriveSetup)) {
        $oneDriveSetup = "$env:SystemRoot\System32\OneDriveSetup.exe"
    }
    if (Test-Path $oneDriveSetup) {
        Start-Process $oneDriveSetup -ArgumentList "/uninstall" -Wait -ErrorAction SilentlyContinue
        Write-Host "  [OK]      OneDrive odinstalowany" -ForegroundColor $colors.Success
    }
    else {
        Write-Host "  [POMIN]   OneDrive - nie znaleziono" -ForegroundColor $colors.DefaultText
    }
}

function Invoke-WindowsUpdateControl {
    Write-Host "`n==== Windows Update - kontrola reczna ====`n" -ForegroundColor $colors.Header

    $wuPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

    Set-RegistryValue -Path $wuPath -Name "AUOptions" -Value 2 | Out-Null
    Set-RegistryValue -Path $wuPath -Name "NoAutoUpdate" -Value 0 | Out-Null
    Set-RegistryValue -Path $wuPath -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 | Out-Null
    Set-RegistryValue -Path $wuPath -Name "AlwaysAutoRebootAtScheduledTime" -Value 0 | Out-Null

    Write-Host "  [OK]      Tryb: tylko powiadamiaj (bez auto-pobierania)" -ForegroundColor $colors.Success
    Write-Host "  [OK]      Auto-restart z zalogowanym userem: wylaczony" -ForegroundColor $colors.Success
    Write-Host "  [OK]      Wymuszony restart po terminie: wylaczony" -ForegroundColor $colors.Success
    Write-Host "`n  [INFO]    Active Hours ustaw recznie:" -ForegroundColor $colors.Warning
    Write-Host "            Settings > Windows Update > Advanced options > Active hours" -ForegroundColor $colors.DefaultText
}

function Invoke-UITweaks {
    Write-Host "`n==== Interfejs - Widgets, Copilot, Game Bar, pasek zadan ====`n" -ForegroundColor $colors.Header

    $advancedPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    # Widgets
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -Value 0 | Out-Null
    Set-RegistryValue -Path $advancedPath -Name "TaskbarDa" -Value 0 | Out-Null
    Write-Host "  [OK]      Widgets wylaczone" -ForegroundColor $colors.Success

    # Copilot
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 | Out-Null
    Set-RegistryValue -Path $advancedPath -Name "ShowCopilotButton" -Value 0 | Out-Null
    Write-Host "  [OK]      Copilot wylaczony" -ForegroundColor $colors.Success

    # Game Bar / GameDVR
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 | Out-Null
    Set-RegistryValue -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 | Out-Null
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 | Out-Null
    Write-Host "  [OK]      Game Bar / GameDVR wylaczone" -ForegroundColor $colors.Success

    # Search icon
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 | Out-Null
    Write-Host "  [OK]      Ikona wyszukiwania ukryta" -ForegroundColor $colors.Success

    # Teams Chat icon
    Set-RegistryValue -Path $advancedPath -Name "TaskbarMn" -Value 0 | Out-Null
    Write-Host "  [OK]      Ikona Chat/Teams usunieta" -ForegroundColor $colors.Success

    # Background apps
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsRunInBackground" -Value 2 | Out-Null
    Write-Host "  [OK]      Aplikacje UWP w tle zablokowane" -ForegroundColor $colors.Success

    # Recall (jesli obecny)
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" -Name "DisableAIDataAnalysis" -Value 1 | Out-Null
    Write-Host "  [OK]      Windows Recall wylaczony" -ForegroundColor $colors.Success

    Write-Host "`n  Restart Explorera..." -ForegroundColor $colors.Info
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Start-Process explorer.exe
    Write-Host "  [OK]      Explorer zrestartowany" -ForegroundColor $colors.Success
}

# endregion

# region INSTALACJA PROGRAMOW

# Szybki zestaw - programy ustalone jako baza pod ten komputer
$quickSet = @(
    @{ Winget = "Python.Python.3.14";          Choco = "python314";          Name = "Python 3.14" },
    @{ Winget = "Microsoft.VisualStudioCode";  Choco = "vscode";             Name = "VS Code" },
    @{ Winget = "Git.Git";                     Choco = "git";                Name = "Git" },
    @{ Winget = "astral-sh.uv";                Choco = "uv";                 Name = "uv (Python pkg manager)" },
    @{ Winget = "Valve.Steam";                 Choco = "steam";              Name = "Steam" },
    @{ Winget = "EpicGames.EpicGamesLauncher"; Choco = "epicgameslauncher";  Name = "Epic Games Launcher" },
    @{ Winget = "GOG.Galaxy";                  Choco = "goggalaxy";          Name = "GOG Galaxy" },
    @{ Winget = "Blizzard.BattleNet";          Choco = "battle.net";         Name = "Battle.net" },
    @{ Winget = "VideoLAN.VLC";                Choco = "vlc";                Name = "VLC" },
    @{ Winget = "RARLab.WinRAR";               Choco = "winrar";             Name = "WinRAR" },
    @{ Winget = "voidtools.Everything";        Choco = "everything";         Name = "Everything" },
    @{ Winget = "Brave.Brave";                 Choco = "brave";              Name = "Brave" }
)

# Cache menedzera pakietow wybranego w tej sesji
$script:PkgManager = $null

function Install-Chocolatey {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "  [OK]      Chocolatey juz zainstalowany" -ForegroundColor $colors.Success
        return $true
    }

    Write-Host "  Instaluje Chocolatey..." -ForegroundColor $colors.Info
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Host "  [OK]      Chocolatey zainstalowany" -ForegroundColor $colors.Success
        return $true
    }
    catch {
        Write-Host "  [BLAD]    $($_.Exception.Message)" -ForegroundColor $colors.Error
        return $false
    }
}

function Install-Winget {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "  [OK]      winget juz zainstalowany" -ForegroundColor $colors.Success
        return $true
    }

    Write-Host "  winget nie znaleziony (LTSC nie ma Microsoft Store)." -ForegroundColor $colors.Warning
    Write-Host "  Instaluje przez PowerShell Gallery..." -ForegroundColor $colors.Info
    try {
        Install-PackageProvider -Name NuGet -Force | Out-Null
        Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery -Scope AllUsers | Out-Null
        Repair-WinGetPackageManager -AllUsers -Force
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Host "  [OK]      winget zainstalowany" -ForegroundColor $colors.Success
        return $true
    }
    catch {
        Write-Host "  [BLAD]    $($_.Exception.Message)" -ForegroundColor $colors.Error
        Write-Host "  Alternatywa: wybierz Chocolatey." -ForegroundColor $colors.Warning
        return $false
    }
}

function Select-PackageManager {
    param([switch]$Force)

    if ($script:PkgManager -and -not $Force) {
        return $script:PkgManager
    }

    $hasChoco = $null -ne (Get-Command choco -ErrorAction SilentlyContinue)
    $hasWinget = $null -ne (Get-Command winget -ErrorAction SilentlyContinue)

    if ($hasChoco -and -not $hasWinget) {
        $script:PkgManager = "choco"
        Write-Host "  [OK]      Uzywam Chocolatey (jedyny dostepny menedzer)" -ForegroundColor $colors.Success
        return $script:PkgManager
    }
    if ($hasWinget -and -not $hasChoco) {
        $script:PkgManager = "winget"
        Write-Host "  [OK]      Uzywam winget (jedyny dostepny menedzer)" -ForegroundColor $colors.Success
        return $script:PkgManager
    }

    Write-Host "`n==== Wybor menedzera pakietow ====`n" -ForegroundColor $colors.Header
    Write-Host "  1" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - Chocolatey"
    Write-Host "  2" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - winget"
    Write-Host "  q" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - Powrot"
    Write-Host ""

    if (-not $hasChoco -and -not $hasWinget) {
        Write-Host "  Nie znaleziono zadnego menedzera. Wybrany zostanie zainstalowany." -ForegroundColor $colors.Warning
    }

    do {
        $pmChoice = Read-Host "Wybierz (1, 2 lub q)"
        switch ($pmChoice) {
            "1" {
                if ($hasChoco -or (Install-Chocolatey)) { $script:PkgManager = "choco" }
            }
            "2" {
                if ($hasWinget -or (Install-Winget)) { $script:PkgManager = "winget" }
            }
            "q" { return $null }
            default { Write-Host "Nieprawidlowy wybor." -ForegroundColor $colors.Error }
        }
    } until ($script:PkgManager)

    return $script:PkgManager
}

function Get-AppPackageSelection {
    param(
        $App,
        [string]$PreferredManager
    )

    $preferredId = if ($PreferredManager -eq "winget") { $App.WingetId } else { $App.ChocoId }
    if (-not [string]::IsNullOrWhiteSpace($preferredId)) {
        return @{ Manager = $PreferredManager; PackageId = $preferredId }
    }

    $otherManager = if ($PreferredManager -eq "winget") { "choco" } else { "winget" }
    $otherId = if ($otherManager -eq "winget") { $App.WingetId } else { $App.ChocoId }

    Write-Host "`n  [BRAK ID] $($App.Name) nie ma identyfikatora dla $PreferredManager." -ForegroundColor $colors.Warning
    if ([string]::IsNullOrWhiteSpace($otherId)) {
        Write-Host "            Brak identyfikatora takze dla drugiego menedzera - pomijam." -ForegroundColor $colors.Warning
        return $null
    }

    $otherAvailable = $null -ne (Get-Command $otherManager -ErrorAction SilentlyContinue)
    if ($otherAvailable) {
        $useOther = Read-Host "Uzyc $otherManager tylko dla programu '$($App.Name)'? (y/n)"
        if ($useOther -ne "y") { return $null }
    }
    else {
        $installOther = Read-Host "$otherManager nie jest zainstalowany. Zainstalowac go i uzyc tylko dla '$($App.Name)'? (y/n)"
        if ($installOther -ne "y") { return $null }

        $installed = if ($otherManager -eq "winget") { Install-Winget } else { Install-Chocolatey }
        if (-not $installed) { return $null }
    }

    return @{ Manager = $otherManager; PackageId = $otherId }
}

function Get-AppsCatalog {
    # 1) Lokalna kopia obok skryptu - dziala offline i przed zalozeniem repo
    $localPaths = @()
    if ($PSScriptRoot) {
        $localPaths += (Join-Path $PSScriptRoot "config\apps.json")
        $localPaths += (Join-Path $PSScriptRoot "apps.json")
    }

    foreach ($path in $localPaths) {
        if (Test-Path $path) {
            try {
                Write-Host "  Wczytuje katalog z pliku lokalnego: $path" -ForegroundColor $colors.Info
                return (Get-Content $path -Raw -Encoding UTF8 | ConvertFrom-Json)
            }
            catch {
                Write-Host "  [BLAD]    Nie udalo sie odczytac $path" -ForegroundColor $colors.Error
            }
        }
    }

    # 2) Fallback: pobierz z repo
    $url = "$($script:RepoUrl)/config/apps.json"
    try {
        Write-Host "  Pobieram katalog programow z repo..." -ForegroundColor $colors.Info
        return (Invoke-RestMethod -Uri "$url`?cache=$((Get-Date).Ticks)")
    }
    catch {
        Write-Host "  [BLAD]    Nie udalo sie pobrac apps.json" -ForegroundColor $colors.Error
        Write-Host "            $($_.Exception.Message)" -ForegroundColor $colors.DefaultText
        Write-Host "            Umiesc apps.json w podkatalogu config\ obok skryptu." -ForegroundColor $colors.Warning
        return $null
    }
}

function Test-PackageStatus {
    param(
        [string]$PackageId,
        [string]$Manager
    )

    # Zwraca: available | notfound | ratelimited | error
    try {
        if ($Manager -eq "choco") {
            $out = & choco search $PackageId --exact --limit-output 2>&1 | Out-String
            $exitCode = $LASTEXITCODE

            if ($out -match "429|Too Many Requests|rate limit") { return "ratelimited" }
            if ($exitCode -ne 0) { return "error" }
            if ([string]::IsNullOrWhiteSpace($out)) { return "notfound" }

            $escaped = [regex]::Escape($PackageId)
            if ($out -match "(?im)^\s*$escaped\|") { return "available" }
            return "notfound"
        }
        else {
            $out = & winget show --id $PackageId --exact --accept-source-agreements 2>&1 | Out-String
            if ($LASTEXITCODE -eq 0) { return "available" }
            if ($out -match "429|Too Many Requests") { return "ratelimited" }
            if ($out -match "No package found|Nie znaleziono|No installed package") { return "notfound" }
            return "error"
        }
    }
    catch {
        return "error"
    }
}

function Install-Package {
    param(
        [string]$PackageId,
        [string]$DisplayName,
        [string]$Manager,
        [string]$InstallPath = ""
    )

    Write-Host "`n--- $DisplayName ---" -ForegroundColor $colors.Highlight

    # Bez osobnego sprawdzania dostepnosci - to podwajalo liczbe zapytan
    # do repozytorium i wpadalo w limit 429. Wynik czytamy z samej instalacji.
    if ($Manager -eq "choco") {
        $chocoArgs = @("install", $PackageId, "-y", "--no-progress")
        if (-not [string]::IsNullOrEmpty($InstallPath)) {
            $chocoArgs += "--install-directory=`"$InstallPath`""
        }

        $logFile = Join-Path $env:TEMP "win11tools-choco-$PackageId.log"
        $proc = Start-Process choco -ArgumentList $chocoArgs -Wait -PassThru -NoNewWindow `
                    -RedirectStandardOutput $logFile -RedirectStandardError "$logFile.err"

        $log = ""
        if (Test-Path $logFile)      { $log += (Get-Content $logFile -Raw -ErrorAction SilentlyContinue) }
        if (Test-Path "$logFile.err"){ $log += (Get-Content "$logFile.err" -Raw -ErrorAction SilentlyContinue) }
        Remove-Item $logFile, "$logFile.err" -Force -ErrorAction SilentlyContinue

        # Pokaz kluczowe linie, zeby nie bylo cicho
        if ($log) {
            $log -split "`n" | Where-Object { $_ -match "Installing|installed|ERROR|WARNING|not found|429" } |
                Select-Object -First 6 | ForEach-Object { Write-Host "    $($_.Trim())" -ForegroundColor $colors.DefaultText }
        }

        if ($log -match "429|Too Many Requests|rate limit") {
            Write-Host "  [BLOKADA] Repozytorium Chocolatey ograniczylo zapytania (429)." -ForegroundColor $colors.Error
            Write-Host "            Odczekaj godzine przed kolejna proba." -ForegroundColor $colors.Warning
            return "ratelimited"
        }
        if ($proc.ExitCode -eq 0) {
            Write-Host "  [OK]      Zainstalowano" -ForegroundColor $colors.Success
            return "ok"
        }
        if ($log -match "not found|could not be found|nie znaleziono") {
            Write-Host "  [BRAK]    Pakiet '$PackageId' nie istnieje w repozytorium." -ForegroundColor $colors.Warning
            return "notfound"
        }
        Write-Host "  [BLAD]    Kod wyjscia: $($proc.ExitCode)" -ForegroundColor $colors.Error
        return "error"
    }
    else {
        $wingetArgs = @("install", "--id", $PackageId, "--exact", "--silent",
                        "--accept-package-agreements", "--accept-source-agreements")
        # Battle.net wymaga jawnej sciezki, inaczej zawiesza sie na pytaniu
        if ($PackageId -eq "Blizzard.BattleNet") {
            $wingetArgs += @("--location", "C:\Program Files (x86)\Battle.net")
        }
        elseif (-not [string]::IsNullOrEmpty($InstallPath)) {
            $wingetArgs += @("--location", $InstallPath)
        }

        $out = & winget @wingetArgs 2>&1 | Out-String
        Write-Host $out -ForegroundColor $colors.DefaultText

        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK]      Zainstalowano" -ForegroundColor $colors.Success
            return "ok"
        }
        if ($out -match "No package found|Nie znaleziono") {
            Write-Host "  [BRAK]    Pakiet '$PackageId' nie istnieje w repozytorium." -ForegroundColor $colors.Warning
            return "notfound"
        }
        Write-Host "  [BLAD]    Kod wyjscia: $LASTEXITCODE" -ForegroundColor $colors.Error
        return "error"
    }
}

function Uninstall-Package {
    param(
        [string]$PackageId,
        [string]$DisplayName,
        [string]$Manager
    )

    Write-Host "`n--- Odinstalowuje: $DisplayName ---" -ForegroundColor $colors.Highlight

    if ($Manager -eq "choco") {
        $proc = Start-Process choco -ArgumentList @("uninstall", $PackageId, "-y") -Wait -PassThru -NoNewWindow
        if ($proc.ExitCode -eq 0) {
            Write-Host "  [OK]      Odinstalowano" -ForegroundColor $colors.Success
            return $true
        }
        Write-Host "  [BLAD]    Kod wyjscia: $($proc.ExitCode)" -ForegroundColor $colors.Error
        return $false
    }
    else {
        winget uninstall --id $PackageId --exact --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [OK]      Odinstalowano" -ForegroundColor $colors.Success
            return $true
        }
        Write-Host "  [BLAD]    Kod wyjscia: $LASTEXITCODE" -ForegroundColor $colors.Error
        return $false
    }
}

# ---------------------------------------------------------------------
#  Wyszukiwarka z autouzupelnianiem TAB (przeniesiona z MyTool)
# ---------------------------------------------------------------------

function Find-CommonPrefix($suggestions) {
    if ($suggestions.Count -eq 0) { return "" }
    if ($suggestions.Count -eq 1) { return $suggestions[0] }

    $shortest = $suggestions[0]
    foreach ($s in $suggestions) {
        if ($s.Length -lt $shortest.Length) { $shortest = $s }
    }

    $commonPrefix = ""
    for ($i = 0; $i -lt $shortest.Length; $i++) {
        $char = $shortest[$i]
        $allMatch = $true
        foreach ($s in $suggestions) {
            if ($s[$i] -ne $char) { $allMatch = $false; break }
        }
        if ($allMatch) { $commonPrefix += $char } else { break }
    }
    return $commonPrefix
}

function Get-MatchingApps($allApps, $searchTerm) {
    $found = [System.Collections.Generic.List[object]]::new()
    if ([string]::IsNullOrEmpty($searchTerm)) { return $found }

    for ($i = 0; $i -lt $allApps.Count; $i++) {
        if ($allApps[$i].Name -like "*$searchTerm*") {
            $found.Add(@{ App = $allApps[$i]; OriginalIndex = $i + 1 })
        }
    }
    return $found
}

function Search-Apps-Interactive($allApps) {
    $searchTerm = ""
    $foundApps = [System.Collections.Generic.List[object]]::new()

    while ($true) {
        Clear-Host
        Write-Host "`n==== Wyszukiwanie programow ====`n" -ForegroundColor $colors.Header
        Write-Host "TAB = uzupelnij | BACKSPACE = kasuj | ENTER = wybierz | ESC = wyczysc | Q = powrot" -ForegroundColor $colors.DefaultText
        Write-Host ""

        if ([string]::IsNullOrEmpty($searchTerm)) {
            Write-Host "Wpisz fragment nazwy programu..." -ForegroundColor $colors.Info
        }
        else {
            Write-Host "Szukam: '$searchTerm'" -ForegroundColor $colors.Highlight
            Write-Host ""

            if ($foundApps.Count -eq 0) {
                Write-Host "  Brak wynikow." -ForegroundColor $colors.Error
            }
            else {
                Write-Host "  Znaleziono: $($foundApps.Count)" -ForegroundColor $colors.Success
                Write-Host ""
                $display = $foundApps | Select-Object -First 15
                foreach ($f in $display) {
                    Write-Host ("{0,4}. " -f $f.OriginalIndex) -ForegroundColor $colors.Success -NoNewline
                    Write-Host $f.App.Name -ForegroundColor $colors.Highlight -NoNewline
                    Write-Host " - $($f.App.Description)" -ForegroundColor $colors.DefaultText
                }
                if ($foundApps.Count -gt 15) {
                    Write-Host "  ... i $($foundApps.Count - 15) wiecej (dopisz litery, aby zawezic)" -ForegroundColor $colors.DefaultText
                }
            }
        }

        Write-Host ""
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

        switch ($key.VirtualKeyCode) {
            9 {  # TAB - uzupelnij do wspolnego prefiksu
                $names = [System.Collections.Generic.List[string]]::new()
                foreach ($f in $foundApps) { $names.Add($f.App.Name) }
                if ($names.Count -gt 0) {
                    $prefix = Find-CommonPrefix -suggestions $names
                    if ($prefix.Length -gt $searchTerm.Length) {
                        $searchTerm = $prefix
                        $foundApps = Get-MatchingApps -allApps $allApps -searchTerm $searchTerm
                    }
                }
            }
            8 {  # BACKSPACE
                if ($searchTerm.Length -gt 0) {
                    $searchTerm = $searchTerm.Substring(0, $searchTerm.Length - 1)
                    $foundApps = Get-MatchingApps -allApps $allApps -searchTerm $searchTerm
                }
            }
            13 { # ENTER
                if ($foundApps.Count -eq 0) { continue }
                Write-Host "`nPodaj numery z listy (np. 12,40,113):" -ForegroundColor $colors.Highlight
                $choice = Read-Host
                if (-not [string]::IsNullOrWhiteSpace($choice)) { return $choice }
            }
            27 { # ESC
                $searchTerm = ""
                $foundApps.Clear()
            }
            81 { return $null }  # Q
            3  { return $null }  # CTRL+C
            default {
                $char = $key.Character
                if ($char -match '[a-zA-Z0-9\s\-\.\+]') {
                    $searchTerm += $char
                    $foundApps = Get-MatchingApps -allApps $allApps -searchTerm $searchTerm
                }
            }
        }
    }
}

# ---------------------------------------------------------------------
#  Menu katalogu
# ---------------------------------------------------------------------

function Show-CategoryMenu($appsData) {
    Write-Host "`n==== Katalog programow ====`n" -ForegroundColor $colors.Header

    $total = 0
    for ($i = 0; $i -lt $appsData.Count; $i++) {
        $count = $appsData[$i].Apps.Count
        $total += $count
        Write-Host ("{0,3}. " -f ($i + 1)) -ForegroundColor $colors.Success -NoNewline
        Write-Host ("{0,-45}" -f $appsData[$i].Category) -ForegroundColor $colors.Highlight -NoNewline
        Write-Host ("{0,4} poz." -f $count) -ForegroundColor $colors.DefaultText
    }

    Write-Host ""
    Write-Host ("  Razem w katalogu: {0} programow" -f $total) -ForegroundColor $colors.Info
    Write-Host ""
    Write-Host "  s" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - Szukaj po nazwie (z autouzupelnianiem TAB)"
    Write-Host "  q" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - Powrot"
    Write-Host ""

    return (Read-Host "Wybierz kategorie, 's' lub 'q'")
}

function Show-AppsInCategory($category, $allApps) {
    Write-Host "`n---- $($category.Category) ----`n" -ForegroundColor $colors.Header

    foreach ($app in $category.Apps) {
        # Numer globalny, spojny z wyszukiwarka
        $globalIndex = 0
        for ($i = 0; $i -lt $allApps.Count; $i++) {
            if ([object]::ReferenceEquals($allApps[$i], $app)) {
                $globalIndex = $i + 1
                break
            }
        }
        Write-Host ("{0,4}. " -f $globalIndex) -ForegroundColor $colors.Success -NoNewline
        Write-Host $app.Name -ForegroundColor $colors.Highlight -NoNewline
        Write-Host " - $($app.Description)" -ForegroundColor $colors.DefaultText
    }

    Write-Host ""
    Write-Host "  q" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - Powrot do kategorii"
    Write-Host ""

    return (Read-Host "Podaj numery po przecinku (np. 12,40,113) lub 'q'")
}

function Invoke-AppCatalog {
    $manager = Select-PackageManager
    if (-not $manager) { return }

    $appsData = Get-AppsCatalog
    if (-not $appsData) {
        Read-Host "`nNacisnij Enter, aby kontynuowac..."
        return
    }

    # Plaska lista - numeracja globalna
    $allApps = [System.Collections.Generic.List[object]]::new()
    foreach ($cat in $appsData) {
        if ($null -ne $cat.Apps) { $allApps.AddRange($cat.Apps) }
    }

    do {
        Clear-Host
        $catChoice = Show-CategoryMenu -appsData $appsData
        if ($catChoice -eq "q") { break }

        $appChoiceString = $null

        if ($catChoice -eq "s") {
            $appChoiceString = Search-Apps-Interactive -allApps $allApps
            if ($null -eq $appChoiceString) { continue }
        }
        elseif ($catChoice -match "^\d+$" -and [int]$catChoice -ge 1 -and [int]$catChoice -le $appsData.Count) {
            Clear-Host
            $appChoiceString = Show-AppsInCategory -category $appsData[[int]$catChoice - 1] -allApps $allApps
            if ($appChoiceString -eq "q") { continue }
        }
        else {
            Write-Host "Nieprawidlowy wybor." -ForegroundColor $colors.Error
            Start-Sleep -Milliseconds 900
            continue
        }

        if ([string]::IsNullOrWhiteSpace($appChoiceString)) { continue }

        # Zbierz wybrane pozycje
        $selected = [System.Collections.Generic.List[object]]::new()
        foreach ($num in $appChoiceString.Split(',')) {
            $trimmed = $num.Trim()
            if ($trimmed -match "^\d+$" -and [int]$trimmed -ge 1 -and [int]$trimmed -le $allApps.Count) {
                $selected.Add($allApps[[int]$trimmed - 1])
            }
            else {
                Write-Host "Pominieto nieprawidlowy numer: '$trimmed'" -ForegroundColor $colors.Error
            }
        }

        if ($selected.Count -eq 0) {
            Read-Host "`nNic nie wybrano. Nacisnij Enter..."
            continue
        }

        Write-Host "`nWybrano $($selected.Count) pozycji:" -ForegroundColor $colors.Highlight
        foreach ($s in $selected) { Write-Host "  - $($s.Name)" -ForegroundColor $colors.DefaultText }

        Write-Host "`n  1" -ForegroundColor $colors.Success -NoNewline
        Write-Host " - Zainstaluj"
        Write-Host "  2" -ForegroundColor $colors.Success -NoNewline
        Write-Host " - Odinstaluj"
        $actionChoice = Read-Host "`nWybierz akcje"
        if ($actionChoice -ne "1" -and $actionChoice -ne "2") {
            Write-Host "Nieprawidlowy wybor akcji." -ForegroundColor $colors.Error
            Read-Host "`nNacisnij Enter, aby kontynuowac..."
            continue
        }

        $customPath = ""
        if ($actionChoice -eq "1") {
            $pathChoice = Read-Host "Niestandardowa sciezka instalacji? (y/n)"
            if ($pathChoice -eq 'y') {
                $customPath = Read-Host "Podaj pelna sciezke (np. D:\Programy)"
                Write-Host "  [UWAGA]   Nie wszystkie pakiety wspieraja wlasna sciezke." -ForegroundColor $colors.Warning
            }
        }

        $okCount = 0
        $failCount = 0
        $missingCount = 0
        $aborted = $false

        foreach ($app in $selected) {
            $package = Get-AppPackageSelection -App $app -PreferredManager $manager
            if (-not $package) {
                $missingCount++
                continue
            }

            if ($actionChoice -eq "1") {
                $result = Install-Package -PackageId $package.PackageId -DisplayName $app.Name -Manager $package.Manager -InstallPath $customPath
                switch ($result) {
                    "ok"          { $okCount++ }
                    "notfound"    { $missingCount++ }
                    "ratelimited" {
                        Write-Host "`n  Przerywam - repozytorium zablokowalo zapytania." -ForegroundColor $colors.Error
                        $aborted = $true
                    }
                    default       { $failCount++ }
                }
                if ($aborted) { break }
            }
            elseif ($actionChoice -eq "2") {
                if (Uninstall-Package -PackageId $package.PackageId -DisplayName $app.Name -Manager $package.Manager) {
                    $okCount++
                } else { $failCount++ }
            }
        }

        Write-Host "`n  Zakonczono: $okCount OK, $missingCount brak/pominiete, $failCount bledow" -ForegroundColor $colors.Info
        Read-Host "`nNacisnij Enter, aby kontynuowac..."

    } while ($true)
}

function Invoke-QuickSet {
    $manager = Select-PackageManager
    if (-not $manager) { return }

    Write-Host "`n==== Szybki zestaw ====`n" -ForegroundColor $colors.Header

    for ($i = 0; $i -lt $quickSet.Count; $i++) {
        Write-Host ("{0,3}. " -f ($i + 1)) -ForegroundColor $colors.Success -NoNewline
        Write-Host $quickSet[$i].Name -ForegroundColor $colors.Highlight
    }

    Write-Host ""
    Write-Host "  a" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - Zainstaluj wszystko"
    Write-Host "  q" -ForegroundColor $colors.Success -NoNewline
    Write-Host " - Powrot"
    Write-Host ""

    $choice = Read-Host "Wybierz numery po przecinku, 'a' lub 'q'"
    if ($choice -eq "q") { return }

    $selected = @()
    if ($choice -eq "a") {
        $selected = $quickSet
    }
    else {
        foreach ($num in $choice.Split(',')) {
            $trimmed = $num.Trim()
            if ($trimmed -match "^\d+$" -and [int]$trimmed -ge 1 -and [int]$trimmed -le $quickSet.Count) {
                $selected += $quickSet[[int]$trimmed - 1]
            }
            else {
                Write-Host "Pominieto nieprawidlowy numer: '$trimmed'" -ForegroundColor $colors.Error
            }
        }
    }

    $okCount = 0
    $failCount = 0
    $missingCount = 0

    foreach ($app in $selected) {
        $pkgId = if ($manager -eq "choco") { $app.Choco } else { $app.Winget }
        $result = Install-Package -PackageId $pkgId -DisplayName $app.Name -Manager $manager
        switch ($result) {
            "ok"          { $okCount++ }
            "notfound"    { $missingCount++ }
            "ratelimited" {
                Write-Host "`n  Przerywam - repozytorium zablokowalo zapytania." -ForegroundColor $colors.Error
                return
            }
            default       { $failCount++ }
        }
    }

    Write-Host "`n  Zakonczono: $okCount OK, $missingCount brak w repo, $failCount bledow" -ForegroundColor $colors.Info
    Read-Host "`nNacisnij Enter, aby kontynuowac..."
}

# ---------------------------------------------------------------------
#  Skaner martwych pakietow
# ---------------------------------------------------------------------

function Invoke-PackageScan {
    $manager = Select-PackageManager
    if (-not $manager) { return }

    $appsData = Get-AppsCatalog
    if (-not $appsData) {
        Read-Host "`nNacisnij Enter, aby kontynuowac..."
        return
    }

    $allApps = [System.Collections.Generic.List[object]]::new()
    foreach ($cat in $appsData) {
        if ($null -ne $cat.Apps) { $allApps.AddRange($cat.Apps) }
    }

    $idProperty = if ($manager -eq "winget") { "WingetId" } else { "ChocoId" }
    $scanApps = [System.Collections.Generic.List[object]]::new()
    $missingIds = [System.Collections.Generic.List[object]]::new()
    foreach ($app in $allApps) {
        $packageId = $app.$idProperty
        if ([string]::IsNullOrWhiteSpace($packageId)) {
            $missingIds.Add([PSCustomObject]@{
                Name        = $app.Name
                PackageId   = ""
                Status      = "brak $idProperty"
                Description = $app.Description
            })
        }
        else {
            $scanApps.Add($app)
        }
    }

    # Repozytorium Chocolatey ogranicza ruch do ok. 20 zapytan na minute na IP.
    # Po przekroczeniu zwraca 429 i blokuje IP na godzine. Dlatego 4 sekundy
    # przerwy miedzy zapytaniami (ok. 15/min) i twarde przerwanie na 429.
    $delaySeconds = if ($manager -eq "choco") { 4 } else { 0 }
    $estimatedMin = [math]::Ceiling(($scanApps.Count * $delaySeconds) / 60)

    Write-Host "`n==== Skaner pakietow ====`n" -ForegroundColor $colors.Header
    Write-Host "  Menedzer:         $manager" -ForegroundColor $colors.Info
    Write-Host "  Do sprawdzenia:   $($scanApps.Count) pakietow" -ForegroundColor $colors.Info
    Write-Host ("  Bez {0}:       {1}" -f $idProperty, $missingIds.Count) -ForegroundColor $colors.Info
    if ($manager -eq "choco") {
        Write-Host "  Przerwa:          $delaySeconds s miedzy zapytaniami" -ForegroundColor $colors.Info
        Write-Host "  Szacowany czas:   ok. $estimatedMin min" -ForegroundColor $colors.Info
    }
    Write-Host ""
    if ($manager -eq "choco") {
        Write-Host "  UWAGA: repozytorium Chocolatey limituje ok. 20 zapytan/min na IP." -ForegroundColor $colors.Warning
        Write-Host "  Po przekroczeniu blokuje IP na GODZINE (dotyczy tez instalacji)." -ForegroundColor $colors.Warning
        Write-Host "  Skaner celowo zwalnia i przerwie sie sam, jesli wykryje blokade." -ForegroundColor $colors.DefaultText
    }
    Write-Host "  CTRL+C przerywa w dowolnym momencie." -ForegroundColor $colors.DefaultText
    Write-Host ""

    $confirm = Read-Host "Kontynuowac? (y/n)"
    if ($confirm -ne 'y') { return }

    $dead      = [System.Collections.Generic.List[object]]::new()
    $unknown   = [System.Collections.Generic.List[object]]::new()
    $alive     = 0
    $counter   = 0
    $aborted   = $false
    $startTime = Get-Date

    foreach ($app in $scanApps) {
        $counter++
        $percent = [math]::Round(($counter / $scanApps.Count) * 100, 0)

        $elapsed   = ((Get-Date) - $startTime).TotalSeconds
        $remaining = [math]::Round((($scanApps.Count - $counter) * $delaySeconds) / 60, 1)

        Write-Progress -Activity "Weryfikacja pakietow ($manager)" `
                       -Status "$counter / $($scanApps.Count) - $($app.Name) | pozostalo ok. $remaining min" `
                       -PercentComplete $percent

        $packageId = $app.$idProperty
        $status = Test-PackageStatus -PackageId $packageId -Manager $manager

        switch ($status) {
            "available" { $alive++ }
            "notfound"  {
                $dead.Add([PSCustomObject]@{
                    Name        = $app.Name
                    PackageId   = $packageId
                    Status      = "brak w repozytorium"
                    Description = $app.Description
                })
                Write-Host ("  [BRAK]    {0,-35} ({1})" -f $app.Name, $packageId) -ForegroundColor $colors.Warning
            }
            "ratelimited" {
                Write-Host "`n  [BLOKADA] Repozytorium zwrocilo 429 (Too Many Requests)." -ForegroundColor $colors.Error
                Write-Host "            Przerywam skanowanie na pozycji $counter / $($scanApps.Count)." -ForegroundColor $colors.Error
                Write-Host "            Odczekaj GODZINE - kolejna proba odnowi blokade." -ForegroundColor $colors.Warning
                $aborted = $true
            }
            default {
                $unknown.Add([PSCustomObject]@{
                    Name        = $app.Name
                    PackageId   = $packageId
                    Status      = "blad zapytania"
                    Description = $app.Description
                })
                Write-Host ("  [?]       {0,-35} ({1}) - blad zapytania" -f $app.Name, $packageId) -ForegroundColor $colors.DefaultText
            }
        }

        if ($aborted) { break }

        if ($delaySeconds -gt 0 -and $counter -lt $scanApps.Count) {
            Start-Sleep -Seconds $delaySeconds
        }
    }

    Write-Progress -Activity "Weryfikacja pakietow" -Completed

    $duration = [math]::Round(((Get-Date) - $startTime).TotalMinutes, 1)

    Write-Host "`n==== Wynik skanowania ====`n" -ForegroundColor $colors.Header
    if ($aborted) {
        Write-Host "  PRZERWANE przez limit zapytan - wynik jest niepelny." -ForegroundColor $colors.Error
        Write-Host ""
    }
    Write-Host "  Sprawdzono:        $counter z $($scanApps.Count)" -ForegroundColor $colors.Info
    Write-Host "  Dostepne:          $alive" -ForegroundColor $colors.Success
    Write-Host "  Brak w repo:       $($dead.Count)" -ForegroundColor $(if ($dead.Count -gt 0) { $colors.Warning } else { $colors.Success })
    Write-Host "  Brak ID:           $($missingIds.Count)" -ForegroundColor $(if ($missingIds.Count -gt 0) { $colors.Warning } else { $colors.Success })
    Write-Host "  Bledy (niepewne):  $($unknown.Count)" -ForegroundColor $colors.DefaultText
    Write-Host "  Czas:              $duration min" -ForegroundColor $colors.DefaultText

    if ($dead.Count -gt 0 -or $unknown.Count -gt 0 -or $missingIds.Count -gt 0) {
        $all = [System.Collections.Generic.List[object]]::new()
        $all.AddRange($dead)
        $all.AddRange($unknown)
        $all.AddRange($missingIds)

        $suffix = if ($aborted) { "-NIEPELNY" } else { "" }
        $reportPath = Join-Path ([Environment]::GetFolderPath("Desktop")) `
                      "pakiety-do-sprawdzenia-$(Get-Date -Format 'yyyy-MM-dd-HHmm')$suffix.csv"
        try {
            $all | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8
            Write-Host "`n  Raport zapisany:" -ForegroundColor $colors.Success
            Write-Host "  $reportPath" -ForegroundColor $colors.Highlight
            Write-Host "`n  Pozycje ze statusem 'blad zapytania' sprawdz recznie -" -ForegroundColor $colors.DefaultText
            Write-Host "  moga byc sprawne, a blad wynikal z chwilowego problemu sieci." -ForegroundColor $colors.DefaultText
        }
        catch {
            Write-Host "`n  [BLAD]    Nie udalo sie zapisac raportu: $($_.Exception.Message)" -ForegroundColor $colors.Error
        }
    }

    Read-Host "`nNacisnij Enter, aby kontynuowac..."
}

# endregion

# region STATUS

function Show-Status {
    Write-Host "`n==== Status optymalizacji ====`n" -ForegroundColor $colors.Header

    Write-Host "-- Uslugi --" -ForegroundColor $colors.Highlight
    $disabledCount = 0
    $activeCount = 0
    foreach ($svc in $servicesToDisable) {
        $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
        if ($service) {
            $startType = (Get-CimInstance -ClassName Win32_Service -Filter "Name='$($svc.Name)'" -ErrorAction SilentlyContinue).StartMode
            if ($startType -eq "Disabled") {
                $disabledCount++
            }
            else {
                $activeCount++
                Write-Host ("  [AKTYWNA] {0,-20} - {1}" -f $svc.Name, $startType) -ForegroundColor $colors.Warning
            }
        }
    }
    Write-Host ("  Wylaczonych: {0} | Nadal aktywnych: {1}" -f $disabledCount, $activeCount) -ForegroundColor $colors.Info

    Write-Host "`n-- Windows Update --" -ForegroundColor $colors.Highlight
    $auOptions = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -ErrorAction SilentlyContinue).AUOptions
    if ($auOptions -eq 2) {
        Write-Host "  [OK]      Tryb reczny (tylko powiadamiaj)" -ForegroundColor $colors.Success
    }
    else {
        Write-Host "  [BRAK]    Nie skonfigurowano - uruchom opcje 4" -ForegroundColor $colors.Warning
    }

    Write-Host "`n-- Interfejs --" -ForegroundColor $colors.Highlight
    $copilot = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -ErrorAction SilentlyContinue).TurnOffWindowsCopilot
    if ($copilot -eq 1) {
        Write-Host "  [OK]      Copilot wylaczony" -ForegroundColor $colors.Success
    }
    else {
        Write-Host "  [BRAK]    Copilot aktywny - uruchom opcje 5" -ForegroundColor $colors.Warning
    }

    Write-Host "`n-- RAM --" -ForegroundColor $colors.Highlight
    $os = Get-CimInstance Win32_OperatingSystem
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $total = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
    $used = [math]::Round($total - $free, 1)
    Write-Host ("  Uzyte: {0}GB / {1}GB" -f $used, $total) -ForegroundColor $colors.Info

    $topProcesses = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5
    Write-Host "`n  Top 5 procesow (RAM):" -ForegroundColor $colors.Info
    foreach ($proc in $topProcesses) {
        $memMB = [math]::Round($proc.WorkingSet64 / 1MB, 0)
        Write-Host ("    {0,-30} {1,6} MB" -f $proc.ProcessName, $memMB) -ForegroundColor $colors.DefaultText
    }
}

# endregion

# region MENU GLOWNE

do {
    Write-Host ""
    Write-Host "==== Glowne Menu ====" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  -- Optymalizacja --" -ForegroundColor $colors.Header
    Write-Host "  1" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". PELNA OPTYMALIZACJA (2+3+4+5+6 naraz)"
    Write-Host "  2" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Wylacz zbedne uslugi"
    Write-Host "  3" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Telemetria i prywatnosc"
    Write-Host "  4" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Usun UWP bloatware + OneDrive"
    Write-Host "  5" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Windows Update - kontrola reczna"
    Write-Host "  6" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Interfejs (Widgets, Copilot, Game Bar, pasek zadan)"
    Write-Host ""
    Write-Host "  -- Programy --" -ForegroundColor $colors.Header
    Write-Host "  7" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Katalog programow (kategorie + wyszukiwarka)"
    Write-Host "  8" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Szybki zestaw (dev + gaming + multimedia)"
    Write-Host "  9" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Skaner - sprawdz ktore pakiety wylecialy z repozytorium"
    Write-Host ""
    Write-Host "  -- System --" -ForegroundColor $colors.Header
    Write-Host " 10" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Status - sprawdz co juz zrobione"
    Write-Host " 11" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Utworz punkt przywracania systemu"
    Write-Host ""
    Write-Host "  q" -ForegroundColor $colors.Success -NoNewline
    Write-Host ". Zakoncz"
    Write-Host ""
    Write-Host "Wybierz opcje: " -NoNewline

    $menuChoice = Read-Host

    switch ($menuChoice) {
        "1" {
            Write-Host "`nUWAGA: To wykona WSZYSTKIE optymalizacje naraz." -ForegroundColor $colors.Warning
            $confirm = Read-Host "Kontynuowac? (y/n)"
            if ($confirm -eq 'y') {
                $rp = Read-Host "Utworzyc najpierw punkt przywracania? (y/n)"
                if ($rp -eq 'y') { New-SystemRestorePoint }

                Invoke-DisableServices
                Invoke-TelemetryTweaks
                Invoke-RemoveBloatware
                Invoke-WindowsUpdateControl
                Invoke-UITweaks

                Write-Host "`n=====================================================" -ForegroundColor Cyan
                Write-Host " PELNA OPTYMALIZACJA ZAKONCZONA" -ForegroundColor $colors.Success
                Write-Host " Zalecany PELNY RESTART komputera." -ForegroundColor $colors.Warning
                Write-Host "=====================================================" -ForegroundColor Cyan
            }
            Read-Host "`nNacisnij Enter, aby kontynuowac..."
        }
        "2" { Invoke-DisableServices;      Read-Host "`nNacisnij Enter, aby kontynuowac..." }
        "3" { Invoke-TelemetryTweaks;      Read-Host "`nNacisnij Enter, aby kontynuowac..." }
        "4" { Invoke-RemoveBloatware;      Read-Host "`nNacisnij Enter, aby kontynuowac..." }
        "5" { Invoke-WindowsUpdateControl; Read-Host "`nNacisnij Enter, aby kontynuowac..." }
        "6" { Invoke-UITweaks;             Read-Host "`nNacisnij Enter, aby kontynuowac..." }
        "7" { Invoke-AppCatalog }
        "8" { Invoke-QuickSet }
        "9" { Invoke-PackageScan }
        "10" { Show-Status;                Read-Host "`nNacisnij Enter, aby kontynuowac..." }
        "11" { New-SystemRestorePoint;     Read-Host "`nNacisnij Enter, aby kontynuowac..." }
        "q" {
            Write-Host "`nZamykanie Win 11 Tools. Do widzenia!" -ForegroundColor $colors.Success
            break
        }
        default {
            Write-Host "Nieprawidlowy wybor. Sprobuj ponownie..." -ForegroundColor $colors.Error
            Read-Host "Nacisnij Enter, aby kontynuowac..."
        }
    }
} while ($menuChoice -ne "q")

# endregion
