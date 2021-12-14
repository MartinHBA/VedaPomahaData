## have to be in correct path
Set-Location "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie"
& '.\init.ps1'
## set directory for git command to be successful
Set-Location "D:\OneDrive\git\IZA\covid19-data\Vaccination"
git pull

$collection = update-gitVersions -file 'OpenData_Slovakia_Vaccination_Scheduled.csv' -versionListFile "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlistScheduled.txt"

## determine last file name to follow naming convention
$lastFileName = (Get-ChildItem "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\dataScheduled\" | Sort-Object LastWriteTime | Select-Object -last 1).BaseName
$lastFileNameInt = [int]$lastFileName
$i = $lastFileNameInt

get-latestFileVersions -startingIteration $i -uriFirstPart 'https://github.com/Institut-Zdravotnych-Analyz/covid19-data/raw/' -uriLastPart "/Vaccination/OpenData_Slovakia_Vaccination_Scheduled.csv" -collection $collection -targetFolder "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\dataScheduled\"

## add versions to list of collected versions
foreach ($item in $collection) {
    $item | Out-File "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlistScheduled.txt" -Append -Encoding Ascii
}

## calculate trend using python
if ($i) {
    python 'D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\PythonScript\calculateTrendScheduled.py' $i
}

## all files are downloaded now push it to git repo (not IZA but own repo)
Set-Location "D:\OneDrive\git\VedaPomahaData"
git add .
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Updated $($timestamp)"
git push
