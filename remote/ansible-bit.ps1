$filePath = "C:\Program Files (x86)\Bitvise SSH Client\BvSsh.exe"
$basePath = "D:\Library\Specialized Library\Documents\profiles\supple\ansible-server.tlp"

Start-Process -FilePath "`"$filePath`"" -ArgumentList "-NoExit", "-File", "`"$basePath`""
