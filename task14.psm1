<#
Функция скачки для N объектов (задается как параметр). 
Дополнительно в режиме диалога задаются символы визуализации. 
#>

$JobFunctions = {
    function StartRiding {
        $RidingFinishNumber = 1000
        for ($CurrentNumber = 0; $CurrentNumber -le $RidingFinishNumber; $CurrentNumber++) {
            Write-Output $($CurrentNumber / $RidingFinishNumber * 100)
            $MillisecondsTimeout = Get-Random -Minimum 10 -Maximum 100
            Start-Sleep -Milliseconds $MillisecondsTimeout
        }
    }
}

function Start-Riding([array] $RiderNames) {
    $RiderIndex = 1
    $Riders = @()
    foreach ($RiderName in $RiderNames) {
        $Riders += @{
            Index = $RiderIndex++;
            Name = $RiderName;
            Job = $(Start-Job -InitializationScript $JobFunctions -ScriptBlock { StartRiding });
            Progress = 0;
        }
    }
    while (Get-Job -State "Running") {
        Start-Sleep -Milliseconds 10
        foreach ($Rider in $Riders) {
            $JobOutput = $Rider.Job | Receive-Job
            if ($JobOutput) {
                $Rider.Progress = $JobOutput | Select-Object -Last 1
            }
            Write-Progress -Id $Rider.Index -Activity $Rider.Name -PercentComplete $Rider.Progress
        }
    }
    Remove-Job *
}

function Start-RidingDialog([int] $RidersNumber = 2) {
    $RiderNames = @()
    for ($RiderIndex = 1; $RiderIndex -le $RidersNumber; $RiderIndex++) {
        $RiderNames += $(Read-Host "Rider #$RiderIndex name")
    }
    Start-Riding $RiderNames
}

Export-ModuleMember Start-RidingDialog
Export-ModuleMember Start-Riding
