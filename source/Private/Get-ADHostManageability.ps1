function Get-ADHostManageability {
    [OutputType([System.Collections.Hashtable])]
    # $this[0] : Name = Computername; Value = [array]RemotableHostNames
    # $this[1] : Name = Computername; Value = [array]Non-RemotableHostNames
    param (
        [int]$DaysInactive = 90,
        [switch]$Servers,
        [switch]$Workstations,
        [String]$OperatingSystemSearchString,
        [string]$SearchBase = $null
    )
    if ($SearchBase) {
        $Time = (Get-Date).Adddays( - ($DaysInactive))
        $AllComputers = Get-ADComputer -SearchBase $SearchBase -Filter { (LastLogonTimeStamp -gt $time) } -Properties Ipv4address
        $Comps = $allComputers.name
        $Params = @{}
        $Params.ComputerName = @()
        $NoRemoteAccess = @{}
        $NoRemoteAccess.NoRemoteAccess = @()
        foreach ($comp in $comps) {
            $testRemoting = Test-WSMan -ComputerName $comp -ErrorAction SilentlyContinue
            if ($null -ne $testRemoting ) {
                $params.ComputerName += $comp
            }
            else {
                $NoRemoteAccess.NoRemoteAccess += $comp
            }
        }
    }
    else {
        if ($Servers) {
            $Search = "*server*"
        }
        elseif ($Workstations) {
            $Search = "*windows 1*"
        }
        elseif ($OperatingSystemSearchString) {
            $Search = "*" + $OperatingSystemSearchString + "*"
        }
        $Time = (Get-Date).Adddays( - ($DaysInactive))
        $AllComputers = Get-ADComputer -Filter { (LastLogonTimeStamp -gt $time) -and (OperatingSystem -like $search) } -Properties Ipv4address
        $Comps = $allComputers.name
        $Params = @{}
        $Params.ComputerName = @()
        $NoRemoteAccess = @{}
        $NoRemoteAccess.NoRemoteAccess = @()
        foreach ($comp in $comps) {
            $testRemoting = Test-WSMan -ComputerName $comp -ErrorAction SilentlyContinue
            if ($null -ne $testRemoting ) {
                $params.ComputerName += $comp
            }
            else {
                $NoRemoteAccess.NoRemoteAccess += $comp
            }
        }
    }
    return $Params, $NoRemoteAccess
}