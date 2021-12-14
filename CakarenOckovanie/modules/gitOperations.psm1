function update-gitVersions {
    param (
        [string] $file,
        [string] $versionListFile
    )
Set-Location "D:\OneDrive\git\IZA\covid19-data\Vaccination" 
## check if there are newer versions  
## rework needed ## to check just newer than commit , some special git command)

$versionsCheck = git rev-list --all --reverse -- $file
Write-Verbose "$($versionsCheck)"
## collection of newer csv
$collection = @()
## check for each git version if we have it or not, if we don't have it in list let's add it to collection
Write-Verbose "checking in $($versionListFile)"
foreach ($item in $versionsCheck) {
    $SEL = Select-String -Path $versionListFile -Pattern $item

    if (!$SEL) {
        $collection += $item
    }
}

return $collection

}

function  get-latestFileVersions {
    param (
        $collection,
        $uriFirstPart,
        $uriLastPart,
        $targetFolder,
        $startingIteration

    )
    $i = $startingIteration
    foreach ($item in $collection) {
        $i++
        $filename = "$($i).csv"
        $uri = "$($uriFirstPart)$($item)$($uriLastPart)"
        $result = Invoke-WebRequest -Uri $uri -Method GET
        $result.Content | Out-File -FilePath "$($targetFolder)$($filename)" -Encoding "utf8"
    
    }
    
}