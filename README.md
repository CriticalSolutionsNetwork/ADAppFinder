# ADAPPFinder Module
## Find-ADHostApp
### Synopsis
Searches AD Computers uninstall registry nodes for input Strings for installed app finding.
### Syntax
```powershell

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-SearchServers] [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-SearchBase] <String> [-Filter] <String> [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-SearchOSString] <String> [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-SearchWorkstations] [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-ComputerNames] <String[]> [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]

Find-ADHostApp [-AppNames] <String[]> [[-DaystoConsiderAHostInactive] <Int32>] [-Local] [-Report] [-DirPath <String>] [-IncludeWow6432Node] [<CommonParameters>]




```
### Parameters
| Name  | Alias  | Description | Required? | Pipeline Input | Default Value |
| - | - | - | - | - | - |
| <nobr>AppNames</nobr> |  | Array of one or more strings to search for apps: "Spiceworks","Microsoft","Adobe". | true | false |  |
| <nobr>DaystoConsiderAHostInactive</nobr> |  | How many days back to consider an AD Computer last sign in as active. | false | false | 90 |
| <nobr>SearchServers</nobr> |  | Enter one or more filenames. | true | false | False |
| <nobr>SearchBase</nobr> |  | Search a specific Organizational Unit: "OU=Infrastructure,OU=CorpComputers,DC=ad,DC=fabuloso,DC=com". | true | false |  |
| <nobr>Filter</nobr> |  | Use a standard Filter: "Name -like "\\*PDC\\*"". Defaults to Wildcard. | true | false | \\* |
| <nobr>SearchOSString</nobr> |  | Search using custom OS Search String. | true | false |  |
| <nobr>SearchWorkstations</nobr> |  | Search Windows 10 and 11 workstations. | true | false | False |
| <nobr>ComputerNames</nobr> |  | Search using specific hosts assumed to be online. | true | false |  |
| <nobr>Local</nobr> |  | Include the local machine in the scan. If set, ONLY the local computer will be scanned. | true | false | False |
| <nobr>Report</nobr> |  | Enable this switch to output a CSV Report. | false | false | False |
| <nobr>DirPath</nobr> |  | Enter the working directory you wish the report to save to. Default creates C:\\temp. | false | false | C:\\Temp\\ |
| <nobr>IncludeWow6432Node</nobr> |  | Also Search Wow6432Node. | false | false | False |
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

GUID           : \\{F1BECD79-0887-4630-957B-108C894264AD\\}  
DisplayName    : Microsoft Azure AD Connect Health agent for AD DS  
DisplayVersion : 3.1.77.0  
Wow6432Node?   : No  
PSComputerName : pdc-00  
RunspaceId     : 47d370fb-f095-4bcf-a036-40997cb5af12
```
### Links

 - [https://criticalsolutionsnetwork.github.io/ADAppFinder](https://criticalsolutionsnetwork.github.io/ADAppFinder)
