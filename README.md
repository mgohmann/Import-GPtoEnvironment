Import-GroupPolicyEnvironment
=============================

PowerShell Script to import Group Policy settings from production, test or development to another environment.
 
 
   
Active Directory Design
=============================
Your OU design should use a structure similar to this:  
  
domain.local  
|-- DEV  
|-------- Users  
|-------- Workstations   
|----------- Laptops  
|----------- Desktops  
|-- PRD  
|-------- Users  
|-------- Workstations  
|----------- Laptops  
|----------- Desktops  
|-- TST  
|-------- Users  
|-------- Workstations  
|----------- Laptops  
|----------- Desktops  
  
  
  
Group Policy Object Naming Convention
=============================

Each Group Policy Object MUST start with the three character prefix for the name of the environment.   
"PRD"  
"TST"  
"DEV"     
  
For example:  
The Production Workstations GPO is named "PRD Workstations".  
The Test Workstations GPO is named "TST Workstations".  
    
Basic Usage Examples
=============================
  
See examples by using PowerShell help, type: "Get-Help .\Import-GPtoEnvironment.ps1 -examples".
  
