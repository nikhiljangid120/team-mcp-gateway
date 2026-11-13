$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path $PSScriptRoot -Parent) 'lib/find-k3d-cluster.ps1')

$cases = @(
    @{ Json = '[]'; Expected = $null },
    @{ Json = '[{"name":"team-mcp","serversCount":1}]'; Expected = 'team-mcp' },
    @{ Json = '[{"name":"other"},{"name":"team-mcp"},{"name":"third"}]'; Expected = 'team-mcp' },
    @{ Json = '[{"name":"other"}]'; Expected = $null }
)
foreach ($case in $cases) {
    $found = Find-K3dCluster -Json $case.Json -Name 'team-mcp'
    if ($case.Expected -eq $null) {
        if ($null -ne $found) { throw 'Incorrectly detected a nonexistent team-mcp cluster.' }
    } elseif ($null -eq $found -or $found.name -ne $case.Expected) {
        throw 'Failed to detect the existing team-mcp cluster.'
    }
}
Write-Host "PASS: 4 cluster detection cases in PowerShell $($PSVersionTable.PSVersion)"
