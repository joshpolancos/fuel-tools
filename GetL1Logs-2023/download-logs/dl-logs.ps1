param($mname)
$dlStart = "Downloading logs from $mname"
$dlFinish = "Download complete - $mname"

$host.ui.RawUI.WindowTitle = $dlStart
copy "\\$mname\c$\temp\jcp-getl1logs\$mname-logs.zip" .\download-logs -Force
dir ".\download-logs\$mname-logs.zip"
$host.ui.RawUI.WindowTitle = $dlFinish
pause
