## set directory for git command to be successful
Set-Location "D:\OneDrive\git\IZA\covid19-data\Vaccination"
git pull

## load version list that we already have csv for
# $versionsLoad = Get-Content "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlist.txt"

## check if there are newer versions  
## rework needed ## to check just newer than commit , some special git command)
$versionsCheck = git rev-list --all --reverse -- OpenData_Slovakia_Vaccination_Cakaren.csv

## collection of newer csv
$collection = @()
## check for each git version if we have it or not, if we don't have it in list let's add it to collection
foreach ($item in $versionsCheck) {
    $SEL = Select-String -Path "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlist.txt" -Pattern $item

    if (!$SEL) {
        $collection+=$item
}
}
$collection

### useful clutter
##  $versionsCheck | Out-File "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlist.txt" -Force
### git rev-list --all --reverse --pretty=oneline -- OpenData_Slovakia_Vaccination_Cakaren.csv

## determine last file name to follow naming convention
$lastFileName = (Get-ChildItem "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\"| Sort-Object LastWriteTime | Select-Object -last 1).BaseName
$lastFileNameInt = [int]$lastFileName

$i=$lastFileNameInt
foreach ($item in $collection) {
    $i++
    $filename = "$($i).csv"
    $uri = "https://github.com/Institut-Zdravotnych-Analyz/covid19-data/raw/$($item)/Vaccination/OpenData_Slovakia_Vaccination_Cakaren.csv"
    $result = Invoke-WebRequest -Uri $uri -Method GET
    $result.Content | Out-File -FilePath "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\$($filename)"

}





<#


$importedCSV = Import-Csv -Path "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\55.csv"

$data = $importedCSV | %{$_.Dávka} | Group-Object


$TimeOfPublish = ($importedCSV | %{$_.'Čas publikovania'} | Group-Object).Name
$data.'Count' | Where-Object ($_.Name -eq 1)

#>