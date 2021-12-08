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
        $collection += $item
    }
}




### useful clutter
##  $versionsCheck | Out-File "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlist.txt" -Force
### git rev-list --all --reverse --pretty=oneline -- OpenData_Slovakia_Vaccination_Cakaren.csv

## determine last file name to follow naming convention
$lastFileName = (Get-ChildItem "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\" | Sort-Object LastWriteTime | Select-Object -last 1).BaseName
$lastFileNameInt = [int]$lastFileName

$i = $lastFileNameInt
foreach ($item in $collection) {
    $i++
    $filename = "$($i).csv"
    $uri = "https://github.com/Institut-Zdravotnych-Analyz/covid19-data/raw/$($item)/Vaccination/OpenData_Slovakia_Vaccination_Cakaren.csv"
    $result = Invoke-WebRequest -Uri $uri -Method GET
    $result.Content | Out-File -FilePath "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\$($filename)" -Encoding "utf8"

}



## add versions to list of collected versions
foreach ($item in $collection) {
    $item | Out-File "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\versionlist.txt" -Append -Encoding Ascii
}


## calculate trend using python
$env:Path += ";C:\Programs\Python\Python39";
$env:PATHEXT += ";.py"; 
$arg1 = 'D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\PythonScript\calculateTrend.py' 
$arg2 = $lastFileName
python $arg1 $arg2


## all files are downloaded now push it to git repo (not IZA but own repo)
Set-Location "D:\OneDrive\git\VedaPomahaData"
git add .
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "Updated $($timestamp)"
git push
