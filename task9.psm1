<#
Функция устранения в числовом массиве повторяющихся элементов
#>

function Remove-Duplicates {
    param (
        [array] $Array
    )
    return $Array | Sort-Object -Unique
}

Export-ModuleMember Remove-Duplicates
