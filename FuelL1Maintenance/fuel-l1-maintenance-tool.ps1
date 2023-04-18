param(
    [Parameter(Mandatory=$true)]
    [string]$machineName
)

<#
$pumpActiveCodes = "[CAPFH]"
$script:pumpStat = $null
$script:isPumpActive = $null
#>

"-----------------------------------"
"Fuel L1 Maintenance Tool"
"-----------------------------------"

function checkPumpStatus(){

    Invoke-Command -ComputerName $machineName -ScriptBlock {
        
        $pumpActiveCodes = "[CAPFH]"
        $script:pumpStat = $null
        $script:isPumpActive = $null

        function pumpIsActive(){

            $fcsLogFile = "\NextGenFuel\FCSService\Logs\FCS.log"
            [string]$fcsLog = (Get-Content $fcsLogFile | Select-String "Status Event" | select -Last 1)
            $pos = $fcsLog.IndexOf(": ")
            $stat = ($fcsLog.Substring($pos+1)).Trim()
            $script:pumpStat = $stat
            $isActive = $stat -match $pumpActiveCodes

            $script:isPumpActive = $isActive
        }
        
        #Check if pumps are clear
        "Checking if Pumps are clear for maintenance"

        pumpIsActive

        Write-Host $script:pumpStat -NoNewline

        while($script:isPumpActive -eq "True"){
            " | Pump/s is/are active. waiting"
            Start-Sleep -Seconds 5
            pumpIsActive
    
            Write-Host $script:pumpStat -NoNewline
        }

        " | Pumps not active. Proceeding with maintenance"
    }
}


function doMaintenance(){

    
    Invoke-Command -ComputerName $machineName -ScriptBlock{
        $fcsService = "FCSService"
        $optService = "OPTService"
        $tpsService = "TPSPayPumpUSService"
        $fcBasket = "\NextGenFuel\FCSService\FC_baskets\pump*xml"
        $adaptorFiles = "\NextGenFuel\FCSService\Adaptor\Files\*xml"
        $recoverOpt = "\NextGenFuel\OPTService\RecoverOPT\*"

        "`nStopping Fuel Services"
        Stop-Service -Name $fcsService -PassThru
        Stop-Service -Name $optService -PassThru
        Stop-Service -Name $tpsService -PassThru

        "`nWaiting for fuel service processes to end"
        Start-Sleep -Seconds 40

        "`nCleared fc_basket xml files"
        Remove-Item $fcBasket -Force -ErrorAction SilentlyContinue

        "Cleared adaptor xml files"
        Remove-Item $adaptorFiles -Force -ErrorAction SilentlyContinue

        "Cleared recover opt files"
        Remove-Item $recoverOpt -Force -ErrorAction SilentlyContinue

        "`nStarting Fuel Services"
        Start-Service -Name $fcsService -PassThru
        Start-Service -Name $optService -PassThru
        Start-Service -Name $tpsService -PassThru
    }
}

#--------------------------------------------------------------
# _main
#--------------------------------------------------------------


"Testing connection to $machineName"

if(Test-Connection $machineName -Quiet){
    "Good"
    checkPumpStatus
    doMaintenance
    
    <#
    #Check if pumps are clear
    "Checking if Pumps are clear for maintenance"

    pumpIsActive

    Write-Host $script:pumpStat -NoNewline

    while($script:isPumpActive -eq "True"){
        " | Pump/s is/are active. waiting"
        Start-Sleep -Seconds 5
        pumpIsActive
    
        Write-Host $script:pumpStat -NoNewline
    }

    " | Pumps not active. Proceeding with maintenance"
#>


} else {
    "No response from $machineName"
}

"Done"

