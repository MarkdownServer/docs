param(
    [switch]$Serve = $false,
    [string]$DocfxProject = 'docfx_project/docfx.json'
)

if (-not (Test-Path $DocfxProject)) {
    throw "Project at [$DocfxProject] is not valid."
}
Push-Location
try {
    $DocfxProject = (Resolve-Path $DocfxProject).Path.Replace('\', '/');

    $location = Get-Item $DocfxProject

    Set-Location $location.Directory

    [string[]]$arguments = @()

    $command = 'build'

    if ($Serve) {
        $command = 'serve'
    }

    switch ($command) {
    ('build') {
            Get-ChildItem 'M*.yml', 'Xunit*.yml', 'System*.yml' -rec | Remove-Item -rec -for
            Get-ChildItem obj, bin, logs, _site -rec | Remove-Item -rec -for

            $arguments = @( $command, $DocfxProject) 

            $arguments += @(
                '--force'
                , '-l'
                , './logs/docfx.log'
                , '--loglevel'
                , 'Verbose'
                , '--debug'
                , '--debugOutput'
                , './logs'
            );
        }
    ('serve') {
            $arguments = @( $command, '_site') 
        }
    }

    Write-Host $arguments

    & docfx $arguments

}
finally {
    Pop-Location
}