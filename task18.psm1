<#
Создать из powershell в Excel три строки: фамилия, имя, телефон
#>

function Write-RowsToExcel {
    param (
        [System.IO.FileInfo] $FilePath,
        [array] $Rows = @('Name', 'Surname', 'Phone')
    )
    $ExcelApplication = New-Object -ComObject excel.application
    $ExcelApplication.Visible = $true
    $ExcelWorkBook = $ExcelApplication.Workbooks.Add()
    $WorkSheet = $ExcelWorkBook.Worksheets.Item(1)
    $WorkSheet.Name = 'Contacts'
    $CurrentCell = 1
    foreach ($Row in $Rows) {
        $WorkSheet.Cells(1, $CurrentCell++) = $Row
    }
    $WorkSheet.SaveAs([ref] $FilePath.FullName)
    $ExcelApplication.Quit()
}

Export-ModuleMember Write-RowsToExcel
