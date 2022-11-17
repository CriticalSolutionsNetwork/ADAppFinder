function SearchForRegUninstallKey {
    [OutputType([System.Management.Automation.PSCustomObject])]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string[]]$SearchFor,
        [Parameter(
            Position = 1
        )]
        [switch]$Wow6432Node
    )
    $output = @()
    foreach ($item in $SearchFor) {
        $matched = @()
        $results = @()
        Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | `
            ForEach-Object {
            $obj = New-Object psobject
            Add-Member -InputObject $obj -MemberType NoteProperty -Name GUID -Value $_.pschildname
            Add-Member -InputObject $obj -MemberType NoteProperty -Name DisplayName -Value $_.GetValue("DisplayName")
            Add-Member -InputObject $obj -MemberType NoteProperty -Name DisplayVersion -Value $_.GetValue("DisplayVersion")
            if ($Wow6432Node) {
                Add-Member -InputObject $obj -MemberType NoteProperty -Name Wow6432Node? -Value "No"
            }
            $results += $obj
            #$output += $results
        }# End ForEach-Object
        if ($Wow6432Node) {
            Get-ChildItem HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | `
                ForEach-Object {
                $obj = New-Object psobject
                Add-Member -InputObject $obj -MemberType NoteProperty -Name GUID -Value $_.pschildname
                Add-Member -InputObject $obj -MemberType NoteProperty -Name DisplayName -Value $_.GetValue("DisplayName")
                Add-Member -InputObject $obj -MemberType NoteProperty -Name DisplayVersion -Value $_.GetValue("DisplayVersion")
                Add-Member -InputObject $obj -MemberType NoteProperty -Name Wow6432Node? -Value "Yes"
                $results += $obj
            }
        }
        $matched = $results | Sort-Object DisplayName | Where-Object { $_.DisplayName -match $item }
        if ($matched) {
            $output += $matched
        }
        else {
            $obj = New-Object psobject
            Add-Member -InputObject $obj -MemberType NoteProperty -Name GUID -Value "Missing: $item"
            Add-Member -InputObject $obj -MemberType NoteProperty -Name DisplayName -Value "Missing: $item"
            Add-Member -InputObject $obj -MemberType NoteProperty -Name DisplayVersion -Value "Missing: $item"
            Add-Member -InputObject $obj -MemberType NoteProperty -Name Wow6432Node? -Value "Missing: $item"
            $output += $obj
        }
    } # For Each
    return $output
} # End Function