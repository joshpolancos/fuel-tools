#-----------------------------------
# Author: Josiah Polancos
# Date: 04/13/2023
#
# This script will connect to an L1 machine
# and collect the fuel services logs
#-----------------------------------

param($logdate,$machineName)

$basePath = "\temp\jcp-getl1logs"
$log = "$basePath\jcp-getl1logs\log.txt"
$fcsLogPath = "\NextGenFuel\FCSService\Logs"
$optLogPath = "\NextGenFuel\OPTService\Logs"
$tpsLogPath = "\NextGenFuel\TPSPayPumpUSService\Logs"
#$machineName = hostname
$fuelLog = "$machineName-logs"

cd $basePath
mkdir $fuelLog -Force | Out-Null



function copyLogs($loc,$l){
    
    foreach($item in $l){
        copy "$loc\$item" "$basePath\$fuelLog"
    }
}


$fcsLogs = Get-ChildItem $fcsLogPath | where {($_.LastWriteTime -ge "$logdate 0:01 am") -and ($_.LastWriteTime -lt "$logdate 11:59 pm")}
$optLogs = Get-ChildItem $optLogPath | where {($_.LastWriteTime -ge "$logdate 0:01 am") -and ($_.LastWriteTime -lt "$logdate 11:59 pm")}
$tpsLogs = Get-ChildItem $tpsLogPath | where {($_.LastWriteTime -ge "$logdate 0:01 am") -and ($_.LastWriteTime -lt "$logdate 11:59 pm")}

copyLogs $fcsLogPath $fcsLogs
copyLogs $optLogPath $optLogs
copyLogs $tpsLogPath $tpsLogs

Compress-Archive $fuelLog -DestinationPath "$fuelLog"


