function Get-ProcessesByConditions {
    param (
        [string] $TitleStart = "",
        [int] $StartId = 0,
        [int] $EndId = 65535
    )

    $ProcessesByConditions = Get-Process `
        | Where-Object { `
            $_.ProcessName.StartsWith($TitleStart) -and `
            $_.Id -ge $StartId -and `
            $_.Id -le $EndId `
        }
    return $ProcessesByConditions
}

function Get-RunningAndStoppedServicesCount {
    $Services = Get-Service
    $RunningServicesNumber = (`
        $Services `
        | Where-Object { $_.Status -eq "Running" } `
        | Measure-Object `
    ).Count
    $StoppedServicesNumber = (`
        $Services `
        | Where-Object { $_.Status -eq "Stopped" } `
        | Measure-Object `
    ).Count

    $ServiceNumberDiff = $RunningServicesNumber - $StoppedServicesNumber
    if ($ServiceNumberDiff -gt 0) {
        $Message = "Running services number is more on $ServiceNumberDiff"
    }
    elseif ($ServiceNumberDiff -lt 0) {
        $Message = "Stopped services number is more on $(-$ServiceNumberDiff)"
    }
    else {
        $Message = "Running and stopped services numbers are equal"
    }
    return @{
        Running = $RunningServicesNumber;
        Stopped = $StoppedServicesNumber;
        Difference = [System.Math]::Abs($ServiceNumberDiff);
        Message = $Message;
    }
}

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
    Write-Host -ForegroundColor Red "CPUTimeAmount = $($ProcessesInfo.CPUTimeAmount)"
    Write-Host -ForegroundColor Red "RunningProcessesNumber = $($ProcessesInfo.RunningProcessesNumber)"
}

function Get-RunningProcessesInfo {
    $DefaultColor = [System.Console]::ForegroundColor
    [System.Console]::ForegroundColor = "Yellow"
    Get-Process | Format-Table -Property ProcessName, Id, StartTime, CPU
    [System.Console]::ForegroundColor = $DefaultColor
}

Export-ModuleMember -Function 'Get-*'