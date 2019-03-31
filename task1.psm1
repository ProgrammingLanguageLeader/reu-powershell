<#
Выдать красным цветом разницу между запущенными и остановленными сервисами. 
Сформировать осмысленное предложение поясняющее полученное число.
#>

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
    Write-Host -ForegroundColor Red $Message
    return @{
        Running = $RunningServicesNumber;
        Stopped = $StoppedServicesNumber;
        Difference = [System.Math]::Abs($ServiceNumberDiff);
        Message = $Message;
    }
}

Export-ModuleMember Get-RunningAndStoppedServicesCount