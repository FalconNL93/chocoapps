cat .\apps.txt | ForEach-Object { choco install $_ -y}
