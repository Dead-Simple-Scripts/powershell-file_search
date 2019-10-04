#Varriables for root dir, save file, and filename glob
$root = 'C:\path\to\Directory1','C:\path\to\Directory2'
$saveFile = 'C:\Users\forensicuser\Desktop\FileSearch.csv'
$include = "bad.jsp","*.exe"

#Create list of files
$files = Get-ChildItem $root -Include $include -Recurse -Force -ErrorAction:SilentlyContinue

#Results Output
#print header
Write-Output ('"MD5","SHA256","CreateDate","Filename"') | Tee-Object -Append -FilePath $saveFile
foreach ($file in $files)
{
  #Ignore Directories
  if (!$file.PSIsContainer)
  {
    #Calculate File Details
    $md5=(Get-FileHash $file.FullName -Algorithm MD5).Hash
    $sha=(Get-FileHash $file.FullName -Algorithm SHA256).Hash
    $date=($file.CreationTime)
    $fullName=($file.FullName)
    #Print File Details
    Write-Output ('"' + $md5 + '","' + $sha + '",' + $date + ',"' + $fullName + '"') | Tee-Object -Append -FilePath $saveFile
  }
}
