Set-Location "D:\OneDrive\git\IZA\covid19-data\Vaccination"
$versions = git rev-list --all -- OpenData_Slovakia_Vaccination_Cakaren.csv

$i=0
foreach ($item in $versions) {
    $i++
    $filename = "$($i).csv"
    git show $item  | Out-File -FilePath "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\data\$($filename)"
}

# Import-Csv -Path myData.csv