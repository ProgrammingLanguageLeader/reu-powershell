<#
Распределение памяти (набор функций). 
По умолчанию работа ведется на поле из ста элементов. 
В режиме диалога задается имя процесса, объем требуемой ему памяти и символ заполнения. 
Мы можем задавать новые процессы, удалять старые (с освобождением памяти), 
запрашивать состояние поля памяти, запрашивать сжатие в пределах общей памяти.
#>

class MemoryManager {
    hidden static [char] $FREE_MEMORY_SYMBOL = '0'
    hidden static [int] $DEFAULT_MEMORY_SIZE = 100
    hidden [hashtable] $Processes = @{}
    hidden [string] $MemoryMap = [MemoryManager]::FREE_MEMORY_SYMBOL.ToString() * [MemoryManager]::DEFAULT_MEMORY_SIZE
    hidden [int] $AvailableMemory = [MemoryManager]::DEFAULT_MEMORY_SIZE

    [void] StartProcess([string] $ProcessName, [int] $MemorySize, [char] $FillingSymbol) {
        if ($this.AvailableMemory -lt $MemorySize) {
            throw "Memory can not be allocated"
        }
        $this.Processes.Add(
            $ProcessName, @{
                MemorySize = $MemorySize;
                FillingSymbol = $FillingSymbol;
            }
        )
        $this.AllocateMemory($MemorySize, $FillingSymbol)
        Write-Host "Process $ProcessName has started"
    }

    [void] EndProcess([string] $ProcessName) {
        $ProcessSymbol = $this.Processes[$ProcessName].FillingSymbol
        $ProcessMemory = $this.Processes[$ProcessName].MemorySize
        $this.FreeMemory($ProcessMemory, $ProcessSymbol)
        $this.Processes.Remove($ProcessName)
        Write-Host "Process $ProcessName has terminated"
    }

    [string] GetMemoryMap() {
        return $this.MemoryMap
    }

    [hashtable] GetProcesses() {
        return $this.Processes
    }

    hidden AllocateMemory([int] $MemorySize, [char] $FillingSymbol) {
        $MemoryAllocated = 0
        for ($CellIndex = 0; $CellIndex -lt $this.MemoryMap.Length; $CellIndex++) {
            if ($this.MemoryMap[$CellIndex] -eq [MemoryManager]::FREE_MEMORY_SYMBOL) {
                $this.MemoryMap = $this.MemoryMap.Remove($CellIndex, 1).Insert($CellIndex, $FillingSymbol)
                $MemoryAllocated++
            }
            if ($MemoryAllocated -eq $MemorySize) {
                break
            }
        }
        $this.AvailableMemory -= $MemorySize
    }

    hidden FreeMemory([int] $MemorySize, [char] $FillingSymbol) {
        $this.MemoryMap = $this.MemoryMap.Replace($FillingSymbol, [MemoryManager]::FREE_MEMORY_SYMBOL)
        $this.AvailableMemory += $MemorySize
    }
}

function Read-UserCommand() {
    return Read-Host $(
        "Enter your command (start to start process, end to terminate process, " +
        "processes - to get active processes, memory - to get memory map, " + 
        "zip - to compress memory, quit - to end the dialog)"
    )
}

function Start-ProcessDispatcherDialog {
    Write-Host "Dialog was started"
    $MemoryManagerInstance = [MemoryManager]::new()
    $Input = Read-UserCommand
    while ($Input -ne "quit") {
        switch ($Input) {
            "start" {
                try {
                    $ProcessName = Read-Host "Process Name"
                    $MemorySize = Read-Host "Memory Size"
                    $ProcessSymbol = Read-Host "Process Symbol"
                    $MemoryManagerInstance.StartProcess($ProcessName, $MemorySize, $ProcessSymbol)
                }
                catch {
                    Write-Host $_.Exception.Message
                }
            }

            "end" {
                $ProcessName = Read-Host "Process Name"
                $MemoryManagerInstance.EndProcess($ProcessName)
            }

            "processes" {
                $MemoryManagerInstance.GetProcesses()
            }
            
            "memory" {
                $MemoryManagerInstance.GetMemoryMap()
            }

            "zip" {
                Write-Host "Not today (:"
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
