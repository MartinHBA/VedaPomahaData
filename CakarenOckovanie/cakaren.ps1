Set-Location "D:\OneDrive\git\IZA\covid19-data\Vaccination"
$versions = git rev-list --all --reverse -- OpenData_Slovakia_Vaccination_Cakaren.csv

### git rev-list --all --reverse --pretty=oneline -- OpenData_Slovakia_Vaccination_Cakaren.csv

$i=0
foreach ($item in $versions) {
    $i++
    $filename = "$($i).csv"
    $uri = "https://github.com/Institut-Zdravotnych-Analyz/covid19-data/raw/$($item)/Vaccination/OpenData_Slovakia_Vaccination_Cakaren.csv"
    $result = Invoke-WebRequest -Uri $uri -Method GET
    $result.Content | Out-File -FilePath "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\$($filename)"

}

# Import-Csv -Path myData.csv



