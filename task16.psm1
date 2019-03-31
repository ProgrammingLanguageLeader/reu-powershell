<#
Из Word выдать строку «Привет из powershell»
#>

function Write-MessageToWord {
    param (
        [System.IO.FileInfo] $FilePath,
        [string] $Message = "Hello from PowerShell!"
    )
    $WordApplication = New-Object -ComObject word.application
    $WordApplication.Visible = $true
    $Document = $WordApplication.Documents.Add()
    $WordApplication.Selection.TypeText($Message)
    $Document.SaveAs([ref] $FilePath.FullName)
    $WordApplication.Quit()
}

Export-ModuleMember Write-MessageToWord
