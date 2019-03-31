<#
Для активных процессов выдать желтым цветом имя, Id, время запуска.
#>

function Get-RunningProcessesInfo {
    $DefaultColor = [System.Console]::ForegroundColor
    [System.Console]::ForegroundColor = "Yellow"
    Get-Process | Format-Table -Property ProcessName, Id, StartTime, CPU
    [System.Console]::ForegroundColor = $DefaultColor
}

Export-ModuleMember Get-RunningProcessesInfo
