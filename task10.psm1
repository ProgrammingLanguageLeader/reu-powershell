<#
Функция определения количества дней между двумя датами, 
которые задаются как параметры.
#>

function Get-DaysBetweenDates {
    param (
        [datetime] $Start,
        [datetime] $End
    )
    return [System.Math]::Abs(
        (New-TimeSpan -Start $Start -End $End).Days
    )
}

Export-ModuleMember Get-DaysBetweenDates
