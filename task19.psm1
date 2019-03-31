<#
Управление процессами (набор функций). 
В режиме диалога формируется ассоциативный массив: имя_процесса, время завершения. 
При запросе состояния массива должны выдаваться сообщения о завершившихся процессах 
(относительно текущего времени запроса) и такие процессы должны быть уже удалены 
из ассоциативного массива.
#>

class ProcessDispatcher {
    hidden [hashtable] $Processes = @{}
    hidden [datetime] $LastCheck = $(Get-Date)

    [void] AddProcess([string] $ProcessName, [datetime] $EndingTime) {
        if ($EndingTime -le $(Get-Date)) {
            throw "EndingTime must be greater than current time"
        }
        Write-Host "Process $ProcessName has started at $EndingTime"
        $this.Processes.Add($ProcessName, $EndingTime)
    }

    [hashtable] GetProcesses() {
        $this.UpdateState()
        return $this.Processes
    }

    [void] UpdateState() {
        $CurrentMoment = Get-Date
        $ActiveProcesses = @{}
        foreach ($ProcessName in $this.Processes.Keys) {
            $ProcessEndingTime = $this.Processes[$ProcessName]
            if ($ProcessEndingTime -le $CurrentMoment) {
                Write-Host "Process $ProcessName has terminated at $ProcessEndingTime"
            }
            else {
                $ActiveProcesses.Add($ProcessName, $ProcessEndingTime)
            }
        }
        $this.Processes = $ActiveProcesses
    }
}

function Read-UserCommand() {
    return Read-Host $(
        "Enter your command (add to add process, update to " +
        "update dispatcher state, get - to get active processes " + 
        "quit - to end the dialog)"
    )
}

function Start-ProcessDispatcherDialog {
    Write-Host "Dialog was started"
    $ProcessDispatcherInstance = [ProcessDispatcher]::new()
    $Input = Read-UserCommand
    while ($Input -ne "quit") {
        switch ($Input) {
            "add" {
                try {
                    $ProcessName = Read-Host "Process Name"
                    $EndingTime = Read-Host "Ending Time"
                    $ProcessDispatcherInstance.AddProcess($ProcessName, $EndingTime)
                }
                catch {
                    Write-Host $_.Exception.Message
                }
            }

            "update" {
                $ProcessDispatcherInstance.UpdateState()
            }

            "get" {
                $ProcessDispatcherInstance.GetProcesses()
            }
            
            default {
                Write-Host "Unknown command"
            }
        }
        $Input = Read-UserCommand
    }
    Write-Host "Dialog was ended"
}

Export-ModuleMember Start-ProcessDispatcherDialog
Export-ModuleMember ProcessDispatcher
