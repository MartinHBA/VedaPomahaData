## have to be in correct path
Set-Location "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie"
& '.\init.ps1'
## set directory for git command to be successful
Set-Location "D:\OneDrive\git\IZA\covid19-data\Vaccination"
git pull

$collection = update-gitVersions -file 'OpenData_Slovakia_Vaccination_Cakaren.csv' -versionListFile "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlist.txt"

## determine last file name to follow naming convention
$lastFileName = (Get-ChildItem "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\" | Sort-Object LastWriteTime | Select-Object -last 1).BaseName
$lastFileNameInt = [int]$lastFileName
$i = $lastFileNameInt

get-latestFileVersions -startingIteration $i -uriFirstPart 'https://github.com/Institut-Zdravotnych-Analyz/covid19-data/raw/' -uriLastPart "/Vaccination/OpenData_Slovakia_Vaccination_Cakaren.csv" -collection $collection -targetFolder "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\"

## add versions to list of collected versions
foreach ($item in $collection) {
    $item | Out-File "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlist.txt" -Append -Encoding Ascii
}


## calculate trend using python
if ($collection) {
    $numberOfFiles = Get-ChildItem "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\" -File | Measure-Object | ForEach-Object {$_.Count}
    python 'D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\PythonScript\calculateTrend.py' $numberOfFiles
}

## all files are downloaded now push it to git repo (not IZA but own repo)
Set-Location "D:\OneDrive\git\VedaPomahaData"
git add .
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Updated $($timestamp)"
git push
