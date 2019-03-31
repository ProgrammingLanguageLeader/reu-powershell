<#
Выдать процессы имена которых начинаются с заданного символа и идентификаторы которых лежат 
в указанном диапазоне. Оформить как функцию с параметрами: символ, нижний диапазон, верхний диапазон.
#>

function Get-ProcessesByConditions {
    param (
        [string] $TitleStart = "",
        [int16] $StartId = 0,
        [int16] $EndId = 65535
    )

    $ProcessesByConditions = Get-Process `
        | Where-Object { `
            $_.ProcessName.StartsWith($TitleStart) -and `
            $_.Id -ge $StartId -and `
            $_.Id -le $EndId `
        }
    return $ProcessesByConditions
}

Export-ModuleMember Get-ProcessesByConditions
