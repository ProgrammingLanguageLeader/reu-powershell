<#
Создать ярлык на рабочем столе
#>

#Requires -RunAsAdministrator

function Add-DesktopLink {
    param (
        [System.IO.FileInfo] $Target
    )
    $TargetNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($Target.FullName)
    $LinkPath = [System.IO.Path]::Combine("~", "Desktop", $TargetNameWithoutExtension)
    New-Item -Path $LinkPath -ItemType SymbolicLink -Value $Target
}

Export-ModuleMember Add-DesktopLink
