Write-Verbose "Loading init"
Write-Verbose "Setting env for Python..."
$env:Path += ";C:\Programs\Python\Python39";
$env:PATHEXT += ";.py"; 

Write-Verbose "Loading module gitOperations..."
Import-Module ".\modules\gitOperations.psm1" -Force

Write-Verbose "Loading env variables..."
Import-Module ".\env_loader.psm1" -Force