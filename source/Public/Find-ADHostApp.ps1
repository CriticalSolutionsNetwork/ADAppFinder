function Find-ADHostApp {
<#
    .SYNOPSIS
        Searches AD Computers uninstall registry nodes for input Strings for installed app finding.
    .DESCRIPTION
        Searches computers using Invoke-Command passing functions to remote hosts. It will
        search the registry for strings matching a provided array of app names.
    .NOTES
        The function defaults to Searching all remotable host in a domain found to have a login
        within the last 90 days. It does not take into account the state of the product if
        a service is involved. This would require a manual check on the specific service.
    .LINK
        Specify a URI to a help page, this will show when Get-Help -Online is used.
    .EXAMPLE
        Find-ADHostApp -AppNames "Adobe","Microsoft","Carbon" -ComputerNames "pdc-00","pdc-ha-00" -IncludeWow6432Node
            Output:
                GUID           : Missing: Adobe
                DisplayName    : Missing: Adobe
                DisplayVersion : Missing: Adobe
                Wow6432Node?   : Missing: Adobe
                PSComputerName : pdc-00
                RunspaceId     : 47d370fb-f095-4bcf-a036-40997cb5af12

                GUID           : {F1BECD79-0887-4630-957B-108C894264AD}
                DisplayName    : Microsoft Azure AD Connect Health agent for AD DS
                DisplayVersion : 3.1.77.0
                Wow6432Node?   : No
                PSComputerName : pdc-00
                RunspaceId     : 47d370fb-f095-4bcf-a036-40997cb5af12
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Array of one or more strings to search for apps: "Spiceworks","Microsoft","Adobe"',
            Position = 0
        )]
        [string[]]$AppNames,
        [Parameter(
            HelpMessage = 'How many days back to consider an AD Computer last sign in as active',
            ParameterSetName = 'Default',
            Position = 2
        )]
        [Parameter(
            HelpMessage = 'How many days back to consider an AD Computer last sign in as active',
            ParameterSetName = 'SearchWorkstations',
            Position = 2
        )]
        [Parameter(
            HelpMessage = 'How many days back to consider an AD Computer last sign in as active',
            ParameterSetName = 'SearchOSString',
            Position = 2
        )]
        [Parameter(
            HelpMessage = 'How many days back to consider an AD Computer last sign in as active',
            ParameterSetName = 'SearchBase',
            Position = 2
        )]
        [int]$DaystoConsiderAHostInactive = 90,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Default',
            HelpMessage = 'Enter one or more filenames',
            Position = 1
        )]
        [switch]$SearchServers,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'SearchWorkstations',
            HelpMessage = 'Search Windows 10 and 11 workstations',
            Position = 1
        )]
        [switch]$SearchWorkstations,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'SearchOSString',
            HelpMessage = 'Search using custom OS Search String',
            Position = 1
        )]
        [string]$SearchOSString,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'SearchComputers',
            HelpMessage = 'Search using specific hosts assumed to be online.',
            Position = 1
        )]
        [string[]]$ComputerNames,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'SearchBase',
            HelpMessage = 'Search a specific Organizational Unit: "OU=Infrastructure,OU=CorpComputers,DC=ad,DC=fabuloso,DC=com"',
            Position = 1
        )]
        [string]$SearchBase,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'SearchBase',
            HelpMessage = 'Use a standard Filter: "Name -like "*PDC*"". Defaults to Wildcard',
            Position = 3
        )]
        [string]$Filter = "*",
        [Parameter(
            HelpMessage = 'Enable this switch to output a CSV Report.'
        )]
        [switch]$Report,
        [Parameter(
            HelpMessage = 'Enter the working directory you wish the report to save to. Default creates C:\temp'
        )]
        [string]$DirPath = 'C:\Temp\',
        [Parameter(
            HelpMessage = 'Also Search Wow6432Node.'
        )]
        [switch]$IncludeWow6432Node
    )
    begin {
        if (!($script:LogString)) {
            Write-AuditLog -Start
        }
        else {
            Write-AuditLog -BeginFunction
        }
        Write-AuditLog -Message "Starting Find-ADHostApp"
        if ($Report) {
            # Create temp directory if
            [bool]$DirPathCheck = Test-Path -Path $DirPath
            If (!($DirPathCheck)) {
                Try {
                    #If not present then create the dir
                    New-Item -ItemType Directory $DirPath -Force
                }
                Catch {
                    Write-Output "The Directory $DirPath was not created and does not exist. Evalate your permissions or modify the `$DirPath variable to suit."
                    break
                }
            }
        }
        if ($ComputerNames) {
            $computers = $ComputerNames
        } # End if not $ComputerNames
        elseif (($SearchServers) -or ($SearchWorkstations) -or ($SearchOSString)) {
            $Params, $NoRemoteAccess = Get-ADHostManageability -DaysInactive $DaystoConsiderAHostInactive -Servers:$SearchServers -Workstations:$SearchWorkstations -OperatingSystemSearchString $SearchOSString
            if ($params.ComputerName) {
                $computers = $Params.ComputerName
                $NonReachable = $NoRemoteAccess.NoRemoteAcces
            }
            else {
                Write-AuditLog "No computers were found to be online. Exiting."
                break
            }
        }
        elseif ($SearchBase) {
            $Params, $NoRemoteAccess = Get-ADHostManageability -DaysInactive $DaystoConsiderAHostInactive -SearchBase $SearchBase
            if ($params.ComputerName) {
                $computers = $Params.ComputerName
                $NonReachable = $NoRemoteAccess.NoRemoteAcces
            }
            else {
                Write-AuditLog "No computers were found to be online. Exiting."
                break
            }
        }
    } # End Begin Block
    process {
        try {
            Write-AuditLog -Message "Invoking command on remote computers." -Severity "Information"
            Write-AuditLog -Message "The computers are: `n$(($Computers -join ", "))" -Severity "Information"
            $results = Invoke-Command -ComputerName $computers -ScriptBlock ${Function:SearchForRegUninstallKey} -ArgumentList $AppNames, $IncludeWow6432Node
        }
        catch {
            Write-AuditLog -Message "An error occurred while invoking the command on remote computers: $_" -Severity "Error"
        }
    } # End Process Block
    end {
        try {
            if ($Report) {
                if ($ComputerNames) {
                    $results | Export-Csv "$DirPath\$((Get-Date).ToString('yyyy-MM-dd_hh.mm.ss'))_$($env:USERDNSDOMAIN)\ADAppInstallStatus.csv" -NoTypeInformation
                } # End If $ComputerNames
                else {
                    $computers | Out-File "$DirPath\$((Get-Date).ToString('yyyy-MM-dd_hh.mm.ss'))_$($env:USERDNSDOMAIN)\ReachableHosts.txt" -NoTypeInformation
                    $NonReachable | Out-File "$DirPath\$((Get-Date).ToString('yyyy-MM_dd_hh.mm.ss'))_$($env:USERDNSDOMAIN)\NonReachableHosts.txt" -NoTypeInformation
                    $results | Export-Csv "$DirPath\$((Get-Date).ToString('yyyy-MM-dd_hh.mm.ss'))_$($env:USERDNSDOMAIN)\ADAppInstallStatus.csv" -NoTypeInformation
                }
            } # End If $Report
        }
        catch {
            Write-AuditLog -Message "An error occurred during the end block of Find-ADHostApp: $_" -Severity "Error"
        }
        Write-AuditLog -EndFunction
        return $results
    } #End Block
}