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
    hidden static [double] $COMPRESSION_COEFFICIENT = 0.2
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
                Compressed = $false;
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

    [array] GetProcesses() {
        $ProcessesArray = @()
        foreach ($ProcessName in $this.Processes.Keys) {
            $ProcessObject = New-Object -TypeName PSObject
            Add-Member `
                -InputObject $ProcessObject `
                -MemberType NoteProperty `
                -Name ProcessName `
                -Value $ProcessName
            Add-Member `
                -InputObject $ProcessObject `
                -MemberType NoteProperty `
                -Name MemorySize `
                -Value $this.Processes[$ProcessName].MemorySize;
            Add-Member `
                -InputObject $ProcessObject `
                -MemberType NoteProperty `
                -Name Compressed `
                -Value $this.Processes[$ProcessName].Compressed;
            Add-Member `
                -InputObject $ProcessObject `
                -MemberType NoteProperty `
                -Name FillingSymbol `
                -Value $this.Processes[$ProcessName].FillingSymbol;
            $ProcessesArray += $ProcessObject
        }
        return $ProcessesArray
    }

    [void] CompressMemory() {
        foreach ($ProcessName in $this.Processes.Keys) {
            $Process = $this.Processes[$ProcessName]
            if ($Process.Compressed) {
                continue
            }
            $OldMemorySize = $Process.MemorySize
            $FreeMemorySize = [System.Math]::Ceiling($OldMemorySize * [MemoryManager]::COMPRESSION_COEFFICIENT)
            $Process.MemorySize = $OldMemorySize - $FreeMemorySize
            $Process.Compressed = $true
            $this.FreeMemory($FreeMemorySize, $Process.FillingSymbol)
        }
        Write-Host "Memory was compressed"
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
        $MemoryFreed = 0        
        for ($CellIndex = 0; $CellIndex -lt $this.MemoryMap.Length; $CellIndex++) {
            if ($this.MemoryMap[$CellIndex] -eq $FillingSymbol) {
                $this.MemoryMap = $this.MemoryMap.Remove($CellIndex, 1).Insert($CellIndex, [MemoryManager]::FREE_MEMORY_SYMBOL)
                $MemoryFreed++
            }
            if ($MemoryFreed -eq $MemorySize) {
                break
            }
        }
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
                Write-Host ($MemoryManagerInstance.GetProcesses() | Out-String)
            }
            
            "memory" {
                $MemoryManagerInstance.GetMemoryMap()
            }

            "zip" {
                $MemoryManagerInstance.CompressMemory()
            }

            default {
                Write-Host "Unknown command"
            }
        }
        Write-Host ""
        $Input = Read-UserCommand
    }
    Write-Host "Dialog was ended"
}

Export-ModuleMember Start-ProcessDispatcherDialog
Export-ModuleMember ProcessDispatcher
