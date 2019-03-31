<#
Написать функцию с помощью которой можно посмотреть все события в журнале приложений 
за указанный период с ограничением количества (период и ограничение количества передать 
как параметры).
#>

function Get-ApplicationEventLog {
    param (
        [datetime] $After,
        [datetime] $Before,
        [int] $Limit = 100
    )
    if ($After -and $Before) {
        return Get-EventLog -LogName Application -Newest $Limit -After $After -Before $Before
    }
    elseif ($After) {
        return Get-EventLog -LogName Application -Newest $Limit -After $After
    }
    elseif ($Before) {
        return Get-EventLog -LogName Application -Newest $Limit -Before $Before
    }
    return Get-EventLog -LogName Application -Newest $Limit
}

Export-ModuleMember Get-ApplicationEventLog
