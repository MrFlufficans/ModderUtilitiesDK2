$Version = "0.7"
$FPSName = "ModDownloader"
$UtilVersionList = Invoke-RestMethod "https://raw.githubusercontent.com/MrFlufficans/DK2ModderUtilities/master/UtilVersion"
$VersionLine = ($UtilVersionList).split([Environment]::NewLine) | Select-String -Pattern "$FPSName" -SimpleMatch
$VersionLine = $VersionLine.ToString()
$VersionMaster = $VersionLine.SubString(($VersionLine.Length) -3)

$FluffyUtils = "
   ______     ______       __  ____  _ __
  / __/ /_ __/ _/ _/_ __  / / / / /_(_) /__
 / _// / // / _/ _/ // / / /_/ / __/ / (_-<
/_/ /_/\_,_/_//_/ \_, /  \____/\__/_/_/___/
                 /___/
"

Write-Host $FluffyUtils
Write-Host "   You Are Running $FPSName v$Version"
Write-Host "   Hosted On Github.com/MrFlufficans"
if ($VersionMaster -gt $Version) {
    Write-Host "`n  There is a New Version Available v$VersionMaster`n        Would you Like to Update?"
    $ConfirmUpdate = Read-Host "`t`t"
    $ConfirmUpdate = ($ConfirmUpdate.ToLower()).ToString()
    If ($ConfirmUpdate -match '^y(es)?$') {
        $Update = 1
    } else {
        $Update = 0
    }
} else {$Update = 0}

Start-Sleep 1

If ($Update) {
    Write-Host "`nFetching Update"
    $NewVersion = Invoke-RestMethod "https://raw.githubusercontent.com/MrFlufficans/DK2ModderUtilities/master/$FPSName.ps1"
    Start-Sleep 1
    If (Test-Path -Path ".\$FPSName.ps1" -PathType Leaf) {Clear-Content ".\$FPSName.ps1"}
    $NewVersion >> "$FPSName.ps1"
    Write-Host "Script Updated"
    Start-Sleep 1
    Write-Host "Relaunching in 3"
    Start-Sleep 1
    Write-Host "Relaunching in 2"
    Start-Sleep 1
    Write-Host "Relaunching in 1"
    Start-Sleep 1
    Start-Process powershell ".\$FPSName.ps1"
    Exit
} else {}


#Everything Above is just the Auto Update
#Actual Script Below Here

if (Test-Path -Path ".\AuthorSig" -PathType Leaf) {
    $AuthorSig = (Get-Content ".\AuthorSig*").split([Environment]::NewLine)
    if (($AuthorSig | Select-Object -Index 0) -match "https://github.com/*") {
        $AuthorName = ((($AuthorSig | Select-Object -Index 0)).split("/")) | Select-Object -Index 3
        $ModName = ((($AuthorSig | Select-Object -Index 0)).split("/")) | Select-Object -Index 4
        $GithubBranch = ""
        $GithubURL = ($AuthorSig | Select-Object -Index 0)

        $ErrorActionPreference = "silentlycontinue"
        $MasterStatus = (Invoke-WebRequest -uri "$GithubURL/archive/refs/heads/main.zip" -UseBasicParsing -DisableKeepAlive).StatusCode
        $ErrorActionPreference = "continue"

        if ($null -eq $MasterStatus) {$GithubBranch = "/archive/refs/heads/master.zip"} else {$GithubBranch = "/archive/refs/heads/main.zip"}

        $GithubURL = "$GithubURL$GithubBranch"

    } else {

        Write-Host "`n     Found Author Signature File"
        $AuthorName = $AuthorSig | Select-Object -Index 0
        $ModName = $AuthorSig | Select-Object -Index 1
        $GithubBranch = $AuthorSig | Select-Object -Index 2

        Write-Host "   Downloading $ModName`n`t  by $AuthorName"
    }
} else {

    Write-Host "`nI couldn't Find the Author Signature File"
    $InputManually = Read-Host "  Would you Like to Input Manually?"
    $InputManually = ($InputManually.ToLower()).ToString()

    if ($InputManually -match '^y(es)?$') {
        $AuthorName = Read-Host "`nAuthor's Name?"
        $ModName = Read-Host "Mod's Name?"
        $GithubBranch = Read-Host "The Mods Branch on Github?"
        Start-Sleep 1
    } else {
        Write-Host "`n Please Create an Author Signature File"
        Start-Sleep 4
        exit
    }
}
if ($null -eq $GithubURL) {$GithubURL = "https://github.com/$AuthorName/$ModName/archive/refs/heads/$GithubBranch.zip"}
Write-Host "`n   Downloading $ModName`n`tby $AuthorName"
Invoke-RestMethod -uri $GithubURL -OutFile ".\$ModName.zip"
Expand-Archive -Path ".\$ModName.zip" -Destination ".\$ModName" -Force

Start-Sleep 3
Copy-Item -Path ".\$ModName\$ModName*" -Destination ".\Temp$ModName" -Force -Recurse
Remove-Item -Path ".\$ModName.zip" -Recurse
Remove-Item -Path ".\$ModName" -Recurse
Start-Sleep 2
Rename-Item -Path ".\Temp$ModName" -NewName "$ModName"
Write-Host "`n    Mod Downloaded and Extracted!"
Start-Sleep 3

# SIG # Begin signature block
# MIIFUgYJKoZIhvcNAQcCoIIFQzCCBT8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU1b4Tdyp/6RQc+iupduFR5tLt
# /1CgggL2MIIC8jCCAdqgAwIBAgIQGYoxa96RMZtFJxUw11CCBjANBgkqhkiG9w0B
# AQsFADARMQ8wDQYDVQQDDAZGbHVmZnkwHhcNMjIwMTIzMDkxNjQyWhcNMjMwMTIz
# MDkzNjQyWjARMQ8wDQYDVQQDDAZGbHVmZnkwggEiMA0GCSqGSIb3DQEBAQUAA4IB
# DwAwggEKAoIBAQDYrJ4j7LJFBH+2PvcYWG160G89fRdi/tviqPMyiPUprowIohnF
# M/c+/u0xTa1nO0TuYpKVc9cDZpz8kv3y5khYq+3tXGw0Ic4Oa2IWb/8TS8KzA6KE
# H1bU9oV8pbZDby7wEH0WO1wkupt5Iur+uV5axojCrSmVqe4UNWdOhCwUvs0lwUd6
# nzrZiKLKWbY0C73P7tezjvaRb3cJ9ILYCjfb00W7r5qk6A22lF3tSFHJRGJ1bBpe
# mwLkJt4hgQPbs0sCXxfSPZCP8FFKHb+v2BV/u6NcekmZyI4gBIrW0wtRGBCFOEo1
# Zg6NCzlwqPCexfoobP+OG6aFoRgswVzOvbsdAgMBAAGjRjBEMA4GA1UdDwEB/wQE
# AwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUBsXvFb7RTLzhQ/d5
# cvrwxg8QeFowDQYJKoZIhvcNAQELBQADggEBANaNT+up1MUv0PjNc2/c0jFd0phK
# YW0VzU4xHvZcFUCrwLyvB9F4q+r1XoDgXk/mJKQuUiTjOWATIEU6ceySEsKwAzu7
# WvTyCkc+FUEBJjJXOEbA7q0oF6Jf1Z4LIAnQGIPSa5sFACRKINbcjcSCWcIvDHNf
# FUlDNuCuVdijpBKJITZEicXI00pWevPMtqJyxw+JMJ4Sy+LnrEqrZzah6d5swY1J
# 4grlLMijXaqhMGN5gqOTKjxvtXKy8TopBASyTUMWxqfrWBTKljusAMtX6946yxTp
# nPsylbvixVldBCqn4xlW/59yFJQYOQB8NoR+PWqip3OcKI0w3MUei+f3tmcxggHG
# MIIBwgIBATAlMBExDzANBgNVBAMMBkZsdWZmeQIQGYoxa96RMZtFJxUw11CCBjAJ
# BgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0B
# CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAj
# BgkqhkiG9w0BCQQxFgQUc/Y8SxCVdOrci/RcfXVN3d1m7IQwDQYJKoZIhvcNAQEB
# BQAEggEAnH1wOqt/eXRiDpsU7z0Ch55N3NL2K3Gm9txvd1by1MTaRqhQcmToWbnq
# MXpa0BnAMr8m3SXsp2XsZWZyaA/OcJ888YA42+qCH4yJdVhSJfK85QzHeFraEK6E
# wzbwQMaZD6O9/73TE8GZJ9aKISKplzzs0HxUssBnhJSiqcXLEP39QobgqDn2PCvu
# LTG/b26Z26HTrqk/EZ3c5ZOzPUvf/NG+RAKvFSZJYqaG+U7xcTE8H58PEcsmd+ZQ
# pFsHkje7qx+JVr1AzRf+p76yEnYmSdT/ylf1x+y9Z/he5+6KdGPvOndEWErndndm
# ynkJUymzDFDCjrylnY956+CHbub+Xw==
# SIG # End signature block
