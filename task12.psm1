<#
Функция: тест датчика случайных чисел. 
Как параметр задается количество повторений цикла. 
Результат выдавать в виде двух процентов.
#>

function Test-Randomizer {
	param (
		[int] $AttemptsNumber = 1000,
		[int] $Minimum = 0,
		[int] $Maximum = 1000
	)
	$MiddleValue = ($Maximum - $Minumum) / 2
	$LessThanMiddle = 0
	$GreaterThanOrEqualToMiddle = 0
	for ($AttemptNumber = 0; $AttemptNumber -lt $AttemptsNumber; $AttemptNumber += 1) {
		$RandomNumber = Get-Random -Minimum $Minimum -Maximum $Maximum
		if ($RandomNumber -lt $MiddleValue) {
			$LessThanMiddle += 1
		}
		else {
			$GreaterThanOrEqualToMiddle += 1			
		}
	}
	Write-Host "Less than middle - $LessThanMiddle"
	Write-Host "Greater than or equal to middle - $GreaterThanOrEqualToMiddle"
}

Export-ModuleMember Test-Randomizer
