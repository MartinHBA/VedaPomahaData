$uri = 'https://mendel3.bii.a-star.edu.sg/METHODS/corona/gamma/MUTATIONS/data/map_b11529.json'

$result = Invoke-RestMethod -Method Get -Uri $uri 

# $result | Where-Object country -eq Slovakia | Format-Table

# $result | Where-Object country -eq Austria | Format-Table



$CurrentDate = (Get-Date).ToString('yyyy-MM-dd hh:mm:ss')

$finalCollection = @()
foreach ($item in $result) {
    $item | Add-Member DateTime $CurrentDate
    $finalCollection += $item
}


$finalCollection | export-Csv -Append -NoClobber -Force -Encoding utf8 -Path "D:\OneDrive\git\VedaPomahaData\CakarenOckovanie\omicron\omicron.csv"