# =======================
# USB Lab Security Check  
# =======================
function Test-AutoRunStatus {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $regName = "NoDriveTypeAutoRun"

    $value = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

    if ($null -eq $value) {
        return "FAIL - AutoRun policy not configured (defaults to enabled)"
    }
    elseif ($value.$regName -eq 255) {
        return "PASS - AutoRun is disabled on all drive types"
    }
    else {
        return "FAIL - AutoRun is enabled (unsafe) - current value: $($value.$regName)"
    }
}

function Test-USBExecutionPolicy {
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices"
    $regName = "Deny_Execute"

    $value = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

    if ($value -and $value.$regName -eq 1) {
        return "PASS - Execution from removable storage is blocked"
    }
    else {
        return "FAIL - Programs can run from USB drives (unsafe)"
    }
}

Write-Host ""
Write-Host "=== USB Lab Security Check ===" -ForegroundColor Cyan
Write-Host "AutoRun Check:        $(Test-AutoRunStatus)"
Write-Host "USB Execution Check:  $(Test-USBExecutionPolicy)"
Write-Host "================================"
Write-Host ""