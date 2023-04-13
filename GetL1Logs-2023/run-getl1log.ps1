#-----------------------------------
# Author: Josiah Polancos
# Date: 04/13/2023
#
# Trigger getl1logs.ps1 script
# then dl-logs.ps1 after to download
# the logs
#-----------------------------------

"--------------------------------"
"Download L1 Fuel Services Logs"
"--------------------------------"
"Machine Name - L1 server (<DIV><Store>L1)"
"Date - Date of the transaction log to be collected | Format: M/dd/YYYY"
""

$machineName = Read-Host "Machine Name"
$logDate = Read-Host "Date"

"Testing connection to $machineName"
if(Test-Connection $machineName -Quiet){
    
    "good"
    Copy-Item .\jcp-getl1logs\ "\\$machineName\c$\temp" -Recurse -Force
    
    "Collecting logs from $machineName"
    Invoke-Command -ComputerName $machineName -ScriptBlock {

        $logdate = $args[0]
        $mname = $args[1]

        cd "\temp\jcp-getl1logs"
        .\getl1logs.ps1 $logdate $mname

    } -ArgumentList $logDate,$machineName


}else{
    "No response from $machineName"
}

"Download logs"

start powershell -ArgumentList ".\download-logs\dl-logs.ps1 $machineName"

"Done"