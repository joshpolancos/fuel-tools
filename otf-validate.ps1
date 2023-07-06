param(
    [Parameter(Mandatory=$true)]
    [string]$machineName
)

#cls
$machineName
"Running otf validate.."
"///////////////////////////////////////////////////"

Invoke-Command -ComputerName $machineName -ScriptBlock{
    #$otfPath = "\NextGenFuel\OTFListenerService"
    #$opfPath = "\NextGenFuel\OPTService"
    $otfConfig = "\NextGenFuel\OTFListenerService\OTFListener.exe.config"
    $optConfig = "\NextGenFuel\OPTService\OPTService.exe.config"
    $otfMobileLog = "\NextGenFuel\OTFListenerService\logs\OTFMobilePaymentProcessor.log"
    $otfServiceLog = "\NextGenFuel\OTFListenerService\logs\OTFServiceStartClose.log"
    $logFile = "\temp\jcp-otf-survey.txt"

    get-date | Out-File $logFile -Force

    "OPTService status" | Out-File $logFile -Append
    Get-Service -Name OPTService | Out-File $logFile -Append
	
	"OTFListener status" | Out-File $logFile -Append
	Get-Service -Name OTFListenerService | Out-File $logFile -Append

    "Checking OTFMobileProcessor Log" | Out-File $logFile -Append
    Get-Content $otfMobileLog -Tail 15 | Out-File $logFile -Append

    "`nChecking OTFService Log" | Out-File $logFile -Append
    Get-Content $otfServiceLog -Tail 15 | Out-File $logFile -Append
    
    "`nChecking Listener_Port in OTFListener.exe.config" | Out-File $logFile -Append
    Get-Content $otfConfig | Select-String "Listener_Port" | Out-File $logFile -Append
    
    
    "Checking OPT config" | Out-File $logFile -Append
     Get-Content $optConfig | Select-String "OTF" | Out-File $logFile -Append

     "Checking netstat port 9660" | Out-File $logFile -Append
     cmd /c "netstat -a | findstr 9660 || echo no result" | Out-File $logFile -Append

     "`nChecking netstat port 443 " | Out-File $logFile -Append
     cmd /c "netstat -a | findstr 443 || echo no result" | Out-File $logFile -Append

     Get-Content $logFile
       

    #Get-Content "\NextGenFuel\OTFListenerService\OTFListener.exe.config" | Select "Listener_Port"
    
    #Write-Host $otfConfig
    
    #cmd /c "\FuelTools\UnixUtil\grep.exe Port OTFListener.exe.config"
    #dir $otfConfig
}
"///////////////////////////////////////////////////"
"Done"