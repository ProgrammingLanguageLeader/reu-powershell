<#
Функция скачки для двух объектов с визуализацией процесса. 
Имена объектов задавать в режиме диалога. 
#>

$JobFunctions = {
    function StartRiding {
        for ($CurrentNumber = 0; $CurrentNumber -le 100; $CurrentNumber++) {
            Write-Output $CurrentNumber
            $MillisecondsTimeout = Get-Random -Minimum 10 -Maximum 200
            Start-Sleep -Milliseconds $MillisecondsTimeout
        }
    }
}

function Start-Riding {
    param (
        [string] $FirstObjectName = "Dark Side",
        [string] $SecondObjectName = "Light Side"
    )
    $FirstObjectProgress = 0
    $SecondObjectProgress = 0
    $FirstObjectJob = Start-Job -InitializationScript $JobFunctions -ScriptBlock { StartRiding }
    $SecondObjectJob = Start-Job -InitializationScript $JobFunctions -ScriptBlock { StartRiding }
    while (Get-Job -State "Running") {
        Start-Sleep -Milliseconds 10
        $FirstObjectRecieved = $FirstObjectJob | Receive-Job
        if ($FirstObjectRecieved) {
            $FirstObjectProgress = $FirstObjectRecieved | Select-Object -Last 1
        }
        $SecondObjectRecieved = $SecondObjectJob | Receive-Job
        if ($SecondObjectRecieved) {
            $SecondObjectProgress = $SecondObjectRecieved | Select-Object -Last 1
        }
        Write-Progress -Id 1 -Activity $FirstObjectName -PercentComplete $FirstObjectProgress
        Write-Progress -Id 2 -Activity $SecondObjectName -PercentComplete $SecondObjectProgress
    }
    Remove-Job *
}

function Start-RidingDialog {
    $FirstObjectName = Read-Host "The first object name"
    $SecondObjectName = Read-Host "The second object name"
    Start-Riding $FirstObjectName $SecondObjectName
}

Export-ModuleMember Start-RidingDialog
Export-ModuleMember Start-Riding
