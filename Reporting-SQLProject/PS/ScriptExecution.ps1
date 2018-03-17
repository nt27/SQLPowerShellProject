# Variable Decleration
#Need to get the below variable from script
#Reading value from User/Screen
#$SQLServerName = Read-Host "SQL ServerName:"

$SQLServerName = "SQLServer2016"
$DatabaseName = "AWProduct"
$UserName ="ReportUser"
$Password ="******"


## Root Path of Script Fodler
$ScriptRootPath = "C:\ps\SQLProjects\Reporting\Reporting-SQLProject\Reporting-SQLProject\"

$FileDetails = Get-ChildItem $ScriptRootPath -Recurse -Filter *.sql -Exclude *.sqlproj | Sort-Object FullName 

try
{
    ForEach($Files in $FileDetails)
    {
        $ScriptFileName = $Files.FullName
        Invoke-Sqlcmd -ServerInstance $SQLServerName -Database $DatabaseName -Username $UserName -Password $Password -InputFile $ScriptFileName -ErrorAction Stop #-Verbose 
    }
        Write-Host "All Scripts executed successfully!" -ForegroundColor Green 
}
catch
{
    Write-Host "Error Message "$_.Exception.Message
    Write-Host -ForegroundColor Yellow "Execution Terminated at this file: " $Files.FullName 
   
}



