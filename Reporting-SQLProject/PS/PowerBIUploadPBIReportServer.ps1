Function WriteOnHost ([string]$Message)
{
	$TimeStamp = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
	Write-Host  $TimeStamp" ::> $Message" 
}
Function PostRequest(
[string]$Name,
[string]$Type,
[string]$Path,
[string]$ContentFullPath,
[string]$PostUrl)
{
    $Content = ""
   if($ContentFullPath.Length -ne 0) 
   {    
        $ReportContentInBytes = [System.IO.File]::ReadAllBytes($ContentFullPath) 
        $Content = [System.Convert]::ToBase64String($ReportContentInBytes)
   }

    $PostContent = @{
    "Name" = "$Name";
    "@odata.type" = "#Model.$Type";
    "Content" = $Content;
    "ContentType"="";
    "Path" = "$Path";
    } | ConvertTo-Json

    try {
        $response = Invoke-WebRequest -Uri $PostUrl -Method Post -Body $PostContent -UseDefaultCredentials -ContentType "application/json" -ErrorAction:Stop
    }
    catch{
        Write-Host $_.Exception.Message -BackgroundColor Red
        $Check = $Error[0]
    }
}

Function PutRequest(
[string]$Name,
[string]$Type,
[string]$Path,
[string]$ContentFullPath,
[string]$PutUrl,
[string]$ObjectID)
{
    $PutUrl = $PutUrl + "($ObjectID)"
    #write-host $PutUrl
    $Content = ""
   if($ContentFullPath.Length -ne 0) 
   {    
        $ReportContentInBytes = [System.IO.File]::ReadAllBytes($ContentFullPath) 
        $Content = [System.Convert]::ToBase64String($ReportContentInBytes)
   }

    $PostContent = @{
    "Name" = "$Name";
    "@odata.type" = "#Model.$Type";
    "Content" = $Content;
    "ContentType"="";
    "Path" = "$Path";
    } | ConvertTo-Json

    try {
        $response = Invoke-WebRequest -Uri $PutUrl -Method PUT -Body $PostContent -UseDefaultCredentials -ContentType "application/json" -ErrorAction:Stop
    }
    catch{
        Write-Host $_.Exception.Message -BackgroundColor Red
        $Check = $Error[0]
    }
}

Function CheckingFolderReport(
[string]$Name,
[string]$Path,
[string]$GetUrl)
{
    $GetUrl = $GetUrl + "(Path='$Path/$Name')"
       
    try {
        $response = Invoke-WebRequest -Uri $GetUrl -Method GET -UseDefaultCredentials -ContentType "application/json" -ErrorAction:Stop
        If($response.BaseResponse.StatusCode -eq "OK")
        {
            $ObjectId = ($response.content | ConvertFrom-Json).Id
            Return $ObjectId
        }
    }
    catch{
        Return "0"
        #$response
        #Write-Host $_.Exception.Message -BackgroundColor Red
    }
}



$ReportPortalUri = "http://sqlserver2016/PBIReports"
$ReportsSourcePath = "C:\Users\cgiadmin\Desktop\Report\PBIReports\"
$ReportUploadRootPath ="/"

$PostUrl = $ReportPortalUri + "/api/v2.0/CatalogItems/"
$GetPutUrl = $ReportPortalUri + "/api/v2.0/CatalogItems"

WriteOnHost "Power BI Reports Uploading Started....."
    
$DirInfo = Get-ChildItem $ReportsSourcePath -Filter *.PBIX -Recurse
foreach($Files in $DirInfo)
{
    $ReportName = [IO.Path]::GetFileNameWithoutExtension($Files.FullName)
    $ReportDirectory = [IO.Path]::GetDirectoryName($Files.FullName)
    $ReportCurrentDirectory = $ReportDirectory.Split("\")
    $ReportCurrentDirectoryName = $ReportCurrentDirectory[$ReportCurrentDirectory.Length-1]
    $ReportUploadPath = $ReportUploadRootPath + $ReportCurrentDirectoryName
    #Write-Host $ReportCurrentDirectoryName $ReportName $ReportUploadPath
	
    WriteOnHost "Checking Directory::$ReportCurrentDirectoryName"
    $Result = CheckingFolderReport -Name $ReportCurrentDirectoryName -Path $ReportUploadRootPath -GetUrl $GetPutUrl
    If($Result -eq "0")
    {
        WriteOnHost "Creating Directory::$ReportCurrentDirectoryName"
        PostRequest -Name $ReportCurrentDirectoryName -Type "Folder" -Path $ReportUploadRootPath -ContentFullPath "" -PostUrl $PostUrl
    }
	WriteOnHost "Checking Report::$ReportName"
    $ReportCheckingResult = CheckingFolderReport -Name $ReportName -Path $ReportUploadPath -GetUrl $GetPutUrl
    If($ReportCheckingResult -eq "0")
    {
        WriteOnHost "Creating new Report::$ReportName"
        PostRequest -Name $ReportName -Type "PowerBIReport" -Path $ReportUploadPath -ContentFullPath $Files.FullName -PostUrl $PostUrl    
    }
    else
    {
        WriteOnHost "Updating the existing Report::$ReportName" 
        PutRequest -Name $ReportName -Type "PowerBIReport" -Path $ReportUploadPath -ContentFullPath $Files.FullName -PutUrl $GetPutUrl -ObjectID $ReportCheckingResult  
    }    
}
WriteOnHost "Power BI Reports Uploading completed....."
Exit

