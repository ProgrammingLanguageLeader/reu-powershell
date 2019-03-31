<#
Выдать желтым цветом общее время использования центрального процессора активными процессами. 
И, дополнительно, количество таких процессов.
#>

function Get-RunningProcessesCpuTimeAmountAndNumber {
    $RunningProcesses = Get-Process | Where-Object { $_.CPU -gt 0 }
    $CPUTimeAmount = ($RunningProcesses | Measure-Object CPU -Sum).Sum
    $RunningProcessesNumber = ($RunningProcesses | Measure-Object).Count
    return @{
        CPUTimeAmount = $CPUTimeAmount;
        RunningProcessesNumber = $RunningProcessesNumber;
    }
}

function Get-StyledRunningProcessesCpuTimeAmountAndNumber {
    $ProcessesInfo = Get-RunningProcessesCpuTimeAmountAndNumber
    Write-Host -ForegroundColor Yellow "CPU Time Amount = $($ProcessesInfo.CPUTimeAmount)"
    Write-Host -ForegroundColor Yellow "Running Processes Number = $($ProcessesInfo.RunningProcessesNumber)"
}

Export-ModuleMember Get-StyledRunningProcessesCpuTimeAmountAndNumber
