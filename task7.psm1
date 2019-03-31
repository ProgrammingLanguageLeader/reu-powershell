<#
Функция удаления файла (имя задается как параметр функции) 
из заданного каталога (задается в качестве параметра). 
#>

function Remove-FileFromFolder {
    param (
        [System.IO.FileInfo] $File,
        [System.IO.FileInfo] $Folder = "."
    )
    $FileAbsolutePath = Join-Path (Resolve-Path $Folder).Path $File
    Remove-Item $FileAbsolutePath
}

Export-ModuleMember Remove-FileFromFolder
