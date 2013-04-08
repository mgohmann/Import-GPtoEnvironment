<#
.Synopsis
   Imports Group Policy Objects from one environment to the other.
.DESCRIPTION
   Imports Group Policy Objects from one environment to the other. Allows you to make changes in the Test or Development environment then import them into Production when they have been validated.
.EXAMPLE
   .\Import-GPtoEnvironment.ps1 -SourceEnvironment DEV -DestinationEnvironment PRD
   Imports Group Policy objects from DEV into PRD.
.EXAMPLE
   .\Import-GPtoEnvironment.ps1 PRD DEV -Whatif
   Shows what would happen if you imported Group Policy objects from PRD into DEV.
.EXAMPLE
   .\Import-GPtoEnvironment.ps1 DEV PRD -Confirm:$false
   Imports ALL Group Policy objects from DEV into PRD without prompting to confirm for each import operation.
.NOTES
   Warning:
   To use this script you must follow the design guidelines for OU and GPO naming conventions or modify this script to fit your environment.
   Author(s):
   Matt Gohmann, Netgain Technology
   www.netgainhosting.com
   https://github.com/mgohmann/Import-GPtoEnvironment
#>
[CmdletBinding(
    SupportsShouldProcess=$true, 
    ConfirmImpact='High')]
Param (
    # Specify the source environment to import the settings from.
    [Parameter(Mandatory=$true,Position=0)]
    [ValidateNotNullorEmpty()]
    [ValidateSet("PRD", "TST", "DEV")]
    [Alias("From","Source")] 
    [STRING]$SourceEnvironment,

    # Specify the destination environment to apply the settings to.
    [Parameter(Mandatory=$true,Position=1)]
    [ValidateNotNullorEmpty()]
    [ValidateSet("PRD", "TST", "DEV")]
    [Alias("To","Destination")] 
    [STRING]$DestinationEnvironment
)
#REGION Prerequisite items
function Test-ElevatedPrompt {
    Write-Verbose "Testing Admin Role."
    [Boolean]$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent(
    )).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    Write-Output -InputObject $IsAdmin
    }
if(!(Test-ElevatedPrompt)){
    Write-Error -Exception "Permission Denied" -Message "Rerun this in an elevated prompt."
    break
    }

Write-Verbose -Message "Importing Required Modules..."
try {
Import-Module -Name GroupPolicy -ErrorAction Stop
} catch {
    Write-Error -Exception "Could not import required modules." -Message "Check that AD and GP modules are present and rerun."
    break
    }
#ENDREGION

#REGION Core functionality
$SourceEnvironmentGPOs = Get-GPO -All | where {$_.DisplayName -like "$SourceEnvironment*"}
foreach ($GPO in $SourceEnvironmentGPOs){
    $SourceGPO = $GPO.DisplayName
    $DestinationGPO = $GPO.DisplayName.replace($SourceEnvironment,$DestinationEnvironment)
    if ($WhatIfPreference.IsPresent){
        if ($pscmdlet.ShouldProcess($DestinationGPO,"Import-GPtoEnvironment")) {
            Write-Debug "Doing a whatif against the GPO."
            }
        }
    if ($pscmdlet.ShouldProcess($DestinationGPO,"Import-GPtoEnvironment")) {
        Write-Debug "This rather inelegant solution of backing up the gpo then importing it is used because the Copy-GPO or Restore-GPO commands cannot overwrite existing GPOs."
        $path = "C:\GPOtemp"
        if (Test-Path $path){rd $path -Force -Recurse | Out-Null}
        md $path | Out-Null
        Backup-GPO -Guid $GPO.Id.Guid -Path $path | Out-Null
        $GUID = (((Get-ChildItem -Path $path).Name).Replace('{',"")).Replace('}',"")
        Write-Debug "Check Backup."
        Write-Host "`nSettings from $SourceGPO written to:" -ForegroundColor Yellow
        Import-GPO -CreateIfNeeded -BackupId $GUID -Path $path -TargetName $DestinationGPO
        rd C:\GPOtemp -Force -Recurse | Out-Null
        }
    }
#ENDREGION