Import-GroupPolicyEnvironment
=============================

PowerShell Script to import Group Policy changes from a production, test or development environment to another environment.




  
    
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

Each Group Policies Object MUST start with the three digit prefix for the name of the environment.   
"PRD"  
"TST"  
"DEV"     
  
For example:  
The Production Workstations GPO is named "PRD Workstations".  
The Test Workstations GPO is named "TST Workstations".  
  
  
  
Basic Usage Examples
=============================
See the examples in the PowerShell help. Type: "Get-Help .\Import-GPtoEnvironment.ps1 -examples".
