<#
Рекурсивные функции обхода дерева каталогов (три отдельных задания)
#>

function DirInf {
    param (
        [string] $Path = "."
    )
    $DirectoriesCount = (Get-ChildItem $Path -Directory | Measure-Object).Count
    $FilesCount = (Get-ChildItem $Path -File | Measure-Object).Count
    return @{
        "DirectoriesCount" = $DirectoriesCount;
        "FilesCount" = $FilesCount;
    }
}

function CurDirInf {
    param (
        [string] $Path = ".",
        [int16] $DepthLevel = 0
    )
    $DirectoryName = $(Resolve-Path $Path).Path
    $Offset = ""
    for ($Depth = 0; $Depth -lt $DepthLevel; $Depth++) {
        $Offset += "  "
    }
    return "$Offset $DepthLevel $DirectoryName"
}

function GoDirs {
    param (
        [string] $Path = ".",
        [int16] $DepthLevel = 0
    )
    $DirectoryInfo = DirInf -Path $Path
    $DirectoryOutput = `
        "$(CurDirInf -Path $Path -DepthLevel $DepthLevel)" `
        + " | Dirs - $($DirectoryInfo.DirectoriesCount)" `
        + " | Files - $($DirectoryInfo.FilesCount)"
    Write-Host $DirectoryOutput
    $SubDirectories = Get-ChildItem $Path -Directory -Name
    foreach ($SubDirectory in $SubDirectories) {
        $SubDirectoryPath = Join-Path $Path $SubDirectory
        $SubDirectoryDepthLevel = $DepthLevel + 1
        GoDirs -Path $SubDirectoryPath -DepthLevel $SubDirectoryDepthLevel
    }
}

Export-ModuleMember DirInf
Export-ModuleMember CurDirInf
Export-ModuleMember GoDirs
