param(
    [switch]$Serve=$false,
    [string]$DocfxProject = './docfx_project/docfx.json'
)

if(-not (Test-Path $DocfxProject)) { throw "Project at [$DocfxProject] is not valid."}

[string[]]$arguments=@()

$command = 'build'

if($Serve){
    $command="serve"
}

$argumentString=Join-String $arguments-Separator " "

& docfx $command $DocfxProject $argumentString
