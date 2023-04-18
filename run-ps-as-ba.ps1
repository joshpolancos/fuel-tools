$ba_username = (whoami) + "-ba"

$ba_username

cmd /c "runas /user:$ba_username powershell"