
Function Send-ToMyGithub {
    $timestamp = get-date -Format "yyyy-MM-dd-HH-mm"
    Set-Location -Path D:\OneDrive\git\VedaPomahaData
    git add .
    git commit -m "updated at $timestamp"
    git push
}

function Get-NCZIvalue {
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        $Pattern,
        $PatternName,
        $htmlbody
    )
    $htmlbody -match $Pattern | Out-Null
    $result = $Matches.$PatternName -replace '\s', ''
    Return $result
}


$uri = "https://korona.gov.sk/koronavirus-na-slovensku-v-cislach/"
$result = Invoke-WebRequest -Method GET -UseBasicParsing -Uri $uri

$Record = [PSCustomObject]@{
    timestamp = get-date -Format "yyyy-MM-dd-HH-mm"
    LastUpdate = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-last-update -->(?<LastUpdate>.*)<!-- /REPLACE -->' -PatternName "LastUpdate"  -htmlbody $result.Content
    LabTests = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-lab-tests -->(?<LabTests>.*)<!-- /REPLACE -->' -PatternName "LabTests"  -htmlbody $result.Content
    LabTestsDelta = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-lab-tests-delta -->(?<LabTestsDelta>.*)<!-- /REPLACE -->' -PatternName "LabTestsDelta"  -htmlbody $result.Content
    Positives = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-positives -->(?<Positives_Result>.*)<!-- /REPLACE -->' -PatternName "Positives_Result"  -htmlbody $result.Content
    PositivesDelta = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-positives-delta -->(?<PositivesDelta>.*)<!-- /REPLACE -->' -PatternName "PositivesDelta"  -htmlbody $result.Content
    AgTests = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-ag-tests -->(?<AgTests>.*)<!-- /REPLACE -->' -PatternName "AgTests"  -htmlbody $result.Content
    AgTestsDelta = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-ag-tests-delta -->(?<AgTestsDelta>.*)<!-- /REPLACE -->' -PatternName "AgTestsDelta"  -htmlbody $result.Content
    AgPositives = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-ag-positives -->(?<AgPositives>.*)<!-- /REPLACE -->' -PatternName "AgPositives"  -htmlbody $result.Content
    AgPositivesDelta = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-ag-positives-delta -->(?<AgPositivesDelta>.*)<!-- /REPLACE -->' -PatternName "AgPositivesDelta"  -htmlbody $result.Content
    Hospitalized = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-hospitalized -->(?<Hospitalized>.*)<!-- /REPLACE -->' -PatternName "Hospitalized"  -htmlbody $result.Content
    HospitalizedDelta = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-hospitalized-delta -->(?<HospitalizedDelta>.*)<!-- /REPLACE -->' -PatternName "HospitalizedDelta"  -htmlbody $result.Content
    HospitalizedCovid19 = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-hospitalized-covid19 -->(?<hospitalizedCovid19>.*)<!-- /REPLACE -->' -PatternName "hospitalizedCovid19"  -htmlbody $result.Content
    HospitalizedCovid19Intensive = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-hospitalized-covid19-intensive -->(?<HospitalizedCovid19Intensive>.*)<!-- /REPLACE --> a na pľúcnej ventilácii' -PatternName "HospitalizedCovid19Intensive"  -htmlbody $result.Content
    HospitalizedCovid19Ventilation = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-hospitalized-covid19-ventilation -->(?<HospitalizedCovid19Ventilation>.*)<!-- /REPLACE -->' -PatternName "HospitalizedCovid19Ventilation"  -htmlbody $result.Content
    Deceased = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-deceased -->(?<Deceased>.*)<!-- /REPLACE -->' -PatternName "Deceased"  -htmlbody $result.Content
    DeceasedDelta = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-deceased-delta -->(?<DeceasedDelta>.*)<!-- /REPLACE -->' -PatternName "DeceasedDelta"  -htmlbody $result.Content
    Cured = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-cured -->(?<Cured>.*)<!-- /REPLACE -->' -PatternName "Cured"  -htmlbody $result.Content
    CuredDelta = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-cured-delta -->(?<CuredDelta>.*)<!-- /REPLACE -->' -PatternName "CuredDelta"  -htmlbody $result.Content
    median = Get-NCZIvalue -Pattern '<!-- REPLACE:koronastats-median -->(?<median>.*)<!-- /REPLACE -->' -PatternName "median"  -htmlbody $result.Content
}



## replace with append to CSV
Write-Host $LabTests, $LabTestsDelta, $Positives, $PositivesDelta, $AgTests, $AgTestsDelta, $AgPositives, $AgPositivesDelta, $Hospitalized, $HospitalizedDelta, $HospitalizedCovid19, $HospitalizedCovid19Intensive, $HospitalizedCovid19Ventilation, $Deceased, $DeceasedDelta, $Cured, $CuredDelta, $median $LastUpdate
$timestamp = get-date -Format "yyyy-MM-dd-HH-mm"
$outfile = ".\koronagovscraping.csv"
 $Record | Export-CSV $outfile  -Encoding UTF8 -Append -Force -NoTypeInformation

Send-ToMyGithub