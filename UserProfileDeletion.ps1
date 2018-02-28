# a list of profiles that should not be removed.
$SkipProfiles=New-Object System.Collections.Generic.List[System.Object]

# Reg path for Profiles info
$profilelistkey='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'

# get path for Public & TSUtech profiles
$SkipProfiles.Add($(Get-ItemProperty -Path $profilelistkey -Name "Public").Default)
$SkipProfiles.Add($(Get-ItemProperty -Path $profilelistkey -Name "tsutech").tsutech)

# get all local or active roaming profiles.
Get-ChildItem -Path $profilelistkey | % {
    $SkipProfiles.Add($(Get-ItemProperty -Path $_.PSPath -Name "ProfileImagePath").ProfileImagePath)
}


# cycle through folders in profile dir.  Skip recent and active folders
Get-ChildItem C:\users\ | ? {
    $_.LastWriteTime -lt (Get-Date).AddDays(-1) -and
    $_.PSIsContainer -and
    -not ($SkipProfiles -contains $_.FullName)
} | % {
    # display and delete crap
    $_
    $_ | Remove-Item -Force -Recurse
}