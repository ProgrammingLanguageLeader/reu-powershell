<#
Функция добавления в указанный каталог текстового файла с заданным содержимым. 
Имя файла, путь к каталогу (при отсутствии работать с текущим каталогом), 
содержимое файла задать в режиме диалога. 
#>

function Add-TextFile {
    $FileName = Read-Host "File name"
    $FolderPath = Read-Host "Folder path (default is current directory)"
    if ($FolderPath -eq "") {
        $FolderPath = "."
    }
    $FileContentList = @()
    Write-Host "Enter the file content here (enter ':q' to exit):"
    $Input = Read-Host
    while ($Input -ne ":q") {
        $FileContentList += $Input
        $Input = Read-Host
    }
    $BreakLineChar = "`n"
    if ([System.Environment]::OSVersion.Platform -eq "Win32NT") {
        $BreakLineChar = "`r`n"
    }
    $FileContent = ""
    foreach ($Line in $FileContentList) {
        $FileContent += $Line + $BreakLineChar
    }
    $FileAbsolutePath = Join-Path (Resolve-Path $FolderPath).Path $FileName
    Write-Output $FileContent > $FileAbsolutePath
}

Export-ModuleMember Add-TextFile
