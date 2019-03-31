<#
Даны два целочисленных массива. 
Удалить из первого массива все элементы содержащиеся во втором массиве
#>

function Get-ArrayDifference {
    param (
        [array] $First,
        [array] $Second
    )
    $ArrayDifference = $First
    foreach ($SecondArrayElement in $Second) {
        $ArrayDifference = $ArrayDifference | Where-Object { $_ -ne $SecondArrayElement }
    }
    return $ArrayDifference
}

Export-ModuleMember Get-ArrayDifference
