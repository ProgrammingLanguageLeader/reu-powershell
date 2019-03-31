<#
Функция определения даты и дня недели, отстоящей от 
заданной на указанное количество дней (со знаком + или -). 
Если день недели  - Суббота или Воскресенье, его выдать красным 
цветом, в противном случае желтым. Начальная дата - параметр 
функции, при его отсутствии за дату считать текущую. 
#>

function Get-DateInfoByOffset {
	param(
		[int] $DaysOffset,
		[datetime] $Date = $(Get-Date)
	)
	$OffsetDate = $Date.AddDays($DaysOffset)
	$DayOfWeek = $OffsetDate.DayOfWeek
	$Color = "Yellow"
	if ($DayOfWeek -eq 0 -or $DayOfWeek -eq 6) {
		$Color = "Red"
	}
	Write-Host -ForegroundColor $color $DayOfWeek -NoNewline
	Write-Host " $OffsetDate"
}

Export-ModuleMember Get-DateInfoByOffset
