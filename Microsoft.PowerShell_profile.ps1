# <Verwendung von Github>
# PowerShell: install-module posh-it
# Rep klonen in lokales Verzeichnis: 1. in das entpsrechende Verzeichnis wechseln; 2. git clone Pfad_zum_Online_Repository
# Es gibt den Workflow: WorkingDir -> Index -> Head
# lokale Änderung wird in Index geschrieben: git add <Dateiname> # Änderung vorschlagen
# Änderung comitten: git commit -m "Commit Msg für Alle im Index" # Datei ist jetzt im Head (nicht online)
# ins Online-Repository übertragen: git push origin master # wobei master der branch ist
# Änderungen vom Online-Repository synchronisieren: git pull
# weiter Informationen https://rogerdudler.github.io/git-guide/index.de.html
# </Verwendung von Github>

# 1. Versuch die <Historie>{ über die ps sessions hinweg zu persistieren, weniger erfolgreich, historie war zwar geladen (get-history) aber über F7 oder den Pfeiltasten nicht verfügbar
$MaximumHistoryCount = 100
$Shell = $Host.UI.RawUI
$Shell.WindowTitle = "tell me something..."

#if (!(Test-Path ~\PowerShell -PathType Container))
#{   New-Item ~\PowerShell -ItemType Directory
#}

#function bye
#{   Get-History -Count 100 |Export-CSV ~\PowerShell\history.csv
#    exit
#}

#if (Test-path ~\PowerShell\History.csv)
#{   Import-CSV ~\PowerShell\History.csv |Add-History
#write-host "History geladen"
#}
# ENDE Versuch 1

# 2. Versuch (Quelle: Microsoft) klappt, allerdings gehen die Pfeiltasten nicht fÃ¼r vergangene Sessions, h geht
sv -name HistoryFile -value "C:\users\erhan\documents\windowspowershell\ethist.ps_history"
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFile } | out-null
if (Test-path $HistoryFile) { Import-Clixml $HistoryFile | Add-History }
# if you don't already have this configured...
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
#} </Historie>

# FUNKTIONEN -----------------------------------------------
# letzten Schlagzeilen von spon auflisten{
function Get-spon 
{
	echo SpOn-Schlagzeilen
	#$rssFeed = [xml](New-Object System.Net.WebClient).DownloadString('http://www.spiegel.de/schlagzeilen/tops/index.rss')
	$rssFeed = [xml](New-Object System.Net.WebClient).DownloadString('http://www.spiegel.de/schlagzeilen/index.rss')
	$rssFeed.rss.channel.item | Select-Object title -First 5
} #}

# letzten 10 Emails der default inbox auflisten -> funzt nicht{
Function Get-OutlookInBox 
{  
 Add-type -assembly "Microsoft.Office.Interop.Outlook" | out-null 
 $olFolders = "Microsoft.Office.Interop.Outlook.olDefaultFolders" -as [type]  
 $outlook = new-object -comobject outlook.application 
 $namespace = $outlook.GetNameSpace("MAPI") 
 $folder = $namespace.getDefaultFolder($olFolders::olFolderInBox) 
 $folder.items |  
 Select-Object -Property Subject, ReceivedTime, Importance, SenderName 
}#}

# <geoeffnete Windows Fenster zeigen>{
function windows{ps | where {$_.MainWindowTitle -ne ""}}#}</geoeffnete Windows Fenster zeigen>

# <startet das fom skript für skriptsprachenorientierte programmiersprachen>{
function fomskript{ start FOM:\skript*\skriptsprachen.pdf} #}</>
# <wechselt in das perl verzeichnis>{
function fomperl{sl Fom:\skript*\perl\
ls | sort Name
} # }</>
# <fomskriptorientiert tcp>{
function fomskripttex{ sl FOM:\skript*\Zusamm*\;start Hauptdatei.tcp } #}</>
# kopier eine <leere vorlage> als unterordner in das aktuelle verzeichnis{
function texhere 
{ 
	
		echo LaTeX-Vorlage wird erstellt: $texori.ToString() nach ([string]::Concat($pwd.ToString(),"\conclusion"))
		copy  $texori.ToString() -Destination ([string]::Concat($pwd.ToString(),"\conclusion")) -Recurse
		
} #}</leere Vorlage>
# <BuchWissen> Tex-Datei Öffnen{
function buch{ sl BUCH:\ ; saps Hauptdatei.tcp  }
function wissen{sl WISSEN:; saps Hauptdatei.tcp }
#}</BuchWissen>

# Auflisten <aller Com Objekte> fuer New-Object {
function Get-ComObjects{
gci HKLM:\Software\Classes -ea 0| ? {$_.PSChildName -match '^\w+\.\w+$' -and (gp "$($_.PSPath)\CLSID" -ea 0)}
#| ft PSChildName
} #}</aller Com Objekte>

# Kurzzugriffe für wichtige Pfade{ --------------------------------
# <TeX-Pfade>{
#$texfom = "D:\DropBoxen\Dropbox\FOM\LaTeX_FOMstd_original"
$texori = "D:\DropBoxen\Dropbox\Fom\LaTeX_Leere_Vorlage"
# }</TeX-Pfade>
new-psdrive -name FOM -psprovider FileSystem -root "D:\dropboxen\dropbox\fom\"
new-psdrive -name PROGS -psprovider filesystem -root "C:\Program Files (x86)\"
new-psdrive -name PSHOME -PSProvider filesystem -root C:\Users\Erhan\Documents\WindowsPowerShell
new-psdrive -name eBooks -PSProvider filesystem -root D:\ebooks\
mount -Name BEW -PSProvider FileSystem -Root 'F:\Dokumente und Briefe\Bewerbungen\2015\'
mount -Name CLOUD -PSProvider filesystem -root 'D:\DropBoxen\'
mount -Name TBOX -PSProvider filesystem -root 'D:\DropBoxen\Mediencenter\'
New-PSDrive -Name BUCH -PSProvider filesystem -Root TBOX:\buch\Erfahrungen_in_Deutschland\
mount -Name WISSEN -PSProvider filesystem -root 'F:\Literatur und eigene Arbeiten\Wissenssammlung\'
# }

# <ALIASE>{ ----------------------------------------------------
set-alias -name np -value notepad.exe
set-alias -name np++ -value PROGS:\notepad++\notepad++.exe
# }</ALIASE>

# <Ausgabe aller definierten Funktionen>{
echo ''
echo 'Alle Funktionen:'
get-childitem function:\ | where {$_.Name.Length -gt 2 } | select {$_.Name} | Format-Wide -AutoSize
echo ''
echo 'Alle Laufwerke/Lokationen:'
get-psdrive | where {$_.Name.Length -gt 2 } | select {$_.Name} | Format-Wide -AutoSize
# }</Ausgabe aller definierten Funktionen>

# Startpfad festlegen
sl C:\

# Load posh-git example profile
. 'C:\Users\Erhan\posh-git\profile.example.ps1'

