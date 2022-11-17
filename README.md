# ADAPPFinder Module
[![PSScriptAnalyzer](https://github.com/CriticalSolutionsNetwork/ADAppFinder/actions/workflows/powershell.yml/badge.svg)](https://github.com/CriticalSolutionsNetwork/ADAppFinder/actions/workflows/powershell.yml)
## Find-ADHostApp
### Synopsis
Searches AD Computers uninstall registry nodes for input Strings for installed app finding.
### Syntax
```powershell

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-SearchServers] [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-SearchOSString] <String> [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-SearchWorkstations] [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [-ComputerNames] <String[]> [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [-SearchBase] <String> [-Filter] <String> [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]




```
### Parameters
| Name  | Alias  | Description | Required? | Pipeline Input | Default Value |
| - | - | - | - | - | - |
| <nobr>AppNames</nobr> |  |  | true | false |  |
| <nobr>DaystoConsiderAHostInactive</nobr> |  |  | false | false | 90 |
| <nobr>SearchServers</nobr> |  |  | true | false | False |
| <nobr>SearchWorkstations</nobr> |  |  | true | false | False |
| <nobr>SearchOSString</nobr> |  |  | true | false |  |
| <nobr>ComputerNames</nobr> |  |  | true | false |  |
| <nobr>SearchBase</nobr> |  |  | true | false |  |
| <nobr>Filter</nobr> |  |  | true | false | \* |
| <nobr>Report</nobr> |  |  | false | false | False |
| <nobr>DirPath</nobr> |  |  | false | false | C:\\Temp\\ |
| <nobr>IncludeWow6432Node</nobr> |  |  | false | false | False |
### Outputs
 - System.Management.Automation.PSCustomObject

### Note
The function defaults to Searching all remotable host in a domain found to have a login within the last 90 days. It does not take into account the state of the product if a service is involved. This would require a manual check on the specific service.

### Examples
**EXAMPLE 1**
```powershell
Find-ADHostApp -AppNames "Adobe","Microsoft","Carbon" -ComputerNames "pdc-00","pdc-ha-00" -IncludeWow6432Node
Output:
GUID           : Missing: Adobe
DisplayName    : Missing: Adobe
DisplayVersion : Missing: Adobe
Wow6432Node?   : Missing: Adobe
PSComputerName : pdc-00
RunspaceId     : 47d370fb-f095-4bcf-a036-40997cb5af12
```
GUID           : \{F1BECD79-0887-4630-957B-108C894264AD\}  
DisplayName    : Microsoft Azure AD Connect Health agent for AD DS  
DisplayVersion : 3.1.77.0  
Wow6432Node?   : No  
PSComputerName : pdc-00  
RunspaceId     : 47d370fb-f095-4bcf-a036-40997cb5af12

### Links

 - 
