param(
    [switch]$Serve=$false,
    [string]$DocfxProject = 'docfx_project/docfx.json'
)

if(-not (Test-Path $DocfxProject)) { throw "Project at [$DocfxProject] is not valid."}
Push-Location
try{
$DocfxProject = (Resolve-Path $DocfxProject).Path.Replace("\", "/");

$location=Get-Item $DocfxProject

Set-Location $location.Directory

[string[]]$arguments=@()

$command = 'build'

if($Serve){
    $command="serve"
}

switch($command){
    ('build') {
        $arguments = @( $command, $DocfxProject) 

        $arguments += @(
            '-l'
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

Get-ChildItem obj,bin,logs -rec | Remove-Item -rec -for

Write-Host $arguments

& docfx $arguments

}
finally {
    Pop-Location
}