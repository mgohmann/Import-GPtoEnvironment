Import-GroupPolicyEnvironment
=============================

PowerShell Script to import Group Policy changes from a production, test or development environment to another environment.



Active Directory Design
=============================

Your OU design should have a structure similar to this example:

* Domain.local
- DEV
---- Users
---- Workstations
         DEV Workstations (Linked Group Policy Object)
- PRD
---- Users
---- Workstations
         PRD Workstations (Linked Group Policy Object)
- TST
---- Users
---- Workstations
         TST Workstations (Linked Group Policy Object)



Group Policy Object Naming Convention
=============================

Your Group Policies MUST start with the name of the environment.

For example:
The Development Workstations policy is named "PRD Workstations".
The Production Workstations policy is named "DEV Workstations".
The Test Workstations policy is named "TST Workstations".


Basic Usage Examples
=============================

EXAMPLE
   .\Import-GPtoEnvironment.ps1 -Source DEV -Destination PRD
   Imports Group Policy objects from DEV into PRD.
EXAMPLE
   .\Import-GPtoEnvironment.ps1 PRD DEV -Whatif
   Shows what would happen if you imported Group Policy objects from PRD into DEV.
EXAMPLE
   .\Import-GPtoEnvironment.ps1 DEV PRD -Confirm:$false
   Imports ALL Group Policy objects from DEV into PRD without prompting to confirm for each import operation.

