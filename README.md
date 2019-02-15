# Boardroom Reset Script

### General Function

As is, the script does the following
* Clears all Chrome, Firefox, and IE cache, but keeps the main page and the OneLogin extension
* Clears / Removes all files added (E.g. files in the Downloads Folder, etc.)
* Cleans the Desktop such that any files left that aren't shortcuts are removed
* Removes current Outlook profile, just in case someone logs in as the user
* Removes all temporary remote caching files - such as PuTTY SSH keys, RDP history and credentials, and temporary Windows folders via. Registry
 

### Requirements
- Boardroom user must have 'Log on as Batch Job' security property on the local computer
- computer must have a proper execution policy set to allow the script to run

### Setup

1. Log into boardroom as the regular Boardroom User
2. Open Task Scheduler as Admin, create a scheduled task
Run the task as any user, whether it is logged in or not, and as the highest privileges
Create a Trigger to run the task when any user logs on, repeating every hour and terminated if the task runs for more than 30 minutes

3. Create an action to run PowerShell with the command line arguments being the path of the script (I tend to keep it in the Windows Folder, as per preference)
  
4.	Next, we'll want to allow the Boardroom user to run this job at logon. to do this, 
run secpol.msc as adminthen navigate to Local Policies > User Rights Assignment and add Boardroom to the Log on as Batch Job security property. 
This allows registry keys defined in the script to be executed as the Boardroom user (E.g. HKCU registry tree) rather than a generic user
 
5.	Finally, we'll want to enable a few Group policy changes for the Boardroom User 
Open gpedit.msc as administrator, and enable the following Policies 
Administrative Templates > Control Panel > Personalization >Prevent Changing desktop Background
Administrative Templates > Control Panel > Personalization > Prevent Changing desktop icons
Administrative Templates > Desktop > Don't Save Settings at exit
Administrative Templates > System > Ctrl+Alt+Del Options > Remove Change Password


Script Testing Scenerios include
```
Downloading a file
Cluttering folders
Remoting to a machine and saving credentials
Making changes to the desktop
Attempting to lock the computer
```

## Deployment
If you want to, you can also delve into GPO deployment for certain computers

## Acknowledgments

* u\ErilEskiidsen for Chrome cache and FireFox cache paths outline
