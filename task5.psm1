<#
Вывести в порядке возрастания для процессов, у которых свойство Handles больше указанной величины 
(задать как параметр), в виде таблицы Handles, Name, Description
#>

function Get-FormattedProcessesTable {
    param (
        [int16] $Handles = 0
    )
    Get-Process `
        | Where-Object { $_.Handles -gt $Handles } `
        | Sort-Object Handles `
        | Format-Table Handles, Name, Description
}

Export-ModuleMember Get-FormattedProcessesTable
