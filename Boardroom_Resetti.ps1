<#

Boardroom Reset Script - V. 2.3
- USAGE - 
Functionally resets a boardroom whenever computer is logged off, clearing Chrome, Firefox, Zoom, and other potentially modified items
Author - Patrick Turney

#>

# Mutes all errors, such that the CMD screen won't appear out of thin air in boardrooms
$ErrorActionPreference = "silentlycontinue"


# Clears Specified Chrome Cache (tests to see if it exists, and if it does, remove it)
# Note that the Chrome and Firefox code are modified from Eric Eskildsen's Github Script to keep the OneLogin extension and default start page

#get-process | where-object{$_.name -like "chrome"} | stop-process
$ChromeItems = @('Archived History',
            'Bookmarks'
            'Cache\*',
            'Cache2\entries\*'
            'Cookies',
            'History*',
            'Login Data',
            'Top Sites',
            'Visited Links',
            'Cookies-Journal',
            'Web Data',
            'Media Cache',
            'ChromeDWriteFontCache',
            'Top Sites'
            )
$Folder = "C:\Users\boardroom\AppData\Local\Google\Chrome\User Data\Default"
    $ChromeItems | ForEach-Object { 
        if((Test-Path -Path "$Folder\$_" )){
            Remove-Item "$Folder\$_" -ErrorAction SilentlyContinue -Force -Recurse
        }
    }
#removes the previous folder path
clear-variable "Folder"


# Clears Specified Firefox cache (tests to see if cache exists, if it does, remove it)
$FirefoxItems = @("cache\*.*",
            "cache2\entries\*.*",
            "thumbnails\*",
            "cookies.sqlite",
            "webappsstore.sqlite",
            "chromeappsstore.sqlite"
            )
$folder = "C:\Users\boardroom\AppData\Local\Mozilla\Firefox\Profiles\*.default\"
    $FirefoxItems | ForEach-Object {
        if((test-path -path "$Folder\$_" )){
            remove-item "$Folder\$_" -ErrorAction SilentlyContinue -force -Recurse
        }
    }


# Removes Internet Explorer Cookies

if ((test-path -path "C:\Users\boardroom\AppData\Local\Microsoft\Windows\INetCookies")){
    remove-item "C:\Users\boardroom\AppData\Local\Microsoft\Windows\INetCookies" -ErrorAction SilentlyContinue -Force -Recurse
}

# Removes any sign on associated with Zoom, resetting the profile to its defaults

if ((test-path -path "C:\Users\boardroom\AppData\Roaming\Zoom")){
    remove-item "C:\Users\boardroom\AppData\Roaming\Zoom\data\*" -ErrorAction SilentlyContinue -Force -Recurse
}

# Removes any Skype login's that are stored

remove-item "C:\Users\boardroom\Appdata\Local\Skype\*" -ErrorAction SilentlyContinue -Force -recurse


##TODO: Microsoft Edge for Win10 for Buenos Aires. etc.

# Clears commonly used folders (Downloads, Documents, Pictures, Videos) for boardroom user
$CommonFolders = @(
             "C:\Users\boardroom\Downloads\*",
             "C:\Users\boardroom\Documents\*",
             "C:\Users\boardroom\Pictures\*",
             "C:\Users\boardroom\Videos\*",
             "C:\Users\boardroom\Contacts\*",
             "C:\Users\boardroom\Music\*"
                   )
clear-variable -Name "Folder"                   
foreach($Folder in $CommonFolders){
    remove-item $Folder -ErrorAction SilentlyContinue -Force -Recurse
}


# Removes everything from Desktop that isn't a shortcut (\users\public are icons that are placed in all user's Desktops)
get-childitem "C:\Users\boardroom\Desktop\*" | Where-Object{$_.Fullname -notlike "*.lnk*"} | Remove-Item -Recurse -Force
get-childitem "C:\Users\Public\Desktop\*" | Where-Object{$_.Fullname -notlike "*.lnk*"} | Remove-Item -Recurse -Force

# Removes all credentials for the user via cmdkey.exe (Password Prompt)
cmdkey /list | ForEach-Object{if($_ -like "*Target:*" -and $_ -like "*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}} 

# Remove Temporary Windows Folders, along with all common files
clear-variable "Folder"
$TempItems = @("Windows\Temp",
            "Windows\Prefetch",
            "Documents and Settings\*\Local Settings\Temp",
            "Users\boardroom\Appdata\Local\Temp*"
            )
$Folder = "C:\"
    $TempItems | ForEach-Object {
        if((test-path -path "$Folder\$_" )){
            remove-item "$Folder\$_" -Force -Recurse | Out-Null
        }
    }

#Clear Recycle Bin (Credit Dead_Jester on StackOverflow)

 #Creates a new shell in the Recycle Bin
$Shell = New-Object -ComObject Shell.Application
$Global:Recycler = $Shell.NameSpace(0xa)

 #Removes each item in the recycling bin
foreach($item in $Recycler.Items()){
    Remove-Item -Path $item.Path -Confirm:$false -Force -Recurse
}

# Removes all RDP History and caching (Removes the registry keys associated)
Get-ChildItem "HKCU:\Software\Microsoft\Terminal Server Client"  -Recurse | Remove-ItemProperty -Name UsernameHint -Ea 0
Remove-Item -Path 'HKCU:\Software\Microsoft\Terminal Server Client\servers' -Recurse  2>&1 | Out-Null
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Terminal Server Client\Default' 'MR*'  2>&1 | Out-Null

# Removes Default.rdp file in Documents
$docs = [environment]::getfolderpath("mydocuments") + '\Default.rdp'
remove-item  $docs  -Force  2>&1 | Out-Null

# Removes all PuTTY SSH Keys and pre-auths set by boardroom user 
# (E.g. the authenticity of host rsa key fingerprint is.. message re-appears for security purposes)
Remove-Item -Patch 'HKCU:\Software\SimonTatham\PuTTY\SshHostKeys' -Recurse 2>&1 | Out-Null

# Adds error reporting back to PowerShell
$ErrorActionPreference = "Continue"
