# ps functions

function mik($file)
 {
	<# Der Parameter $file darf keine Extension haben!
	
	 1. Versionierung der PDF erstellen
	  a) Versionsdatei einlesen $ver als int
	  b) Zähler erhöhen +=1
	  c) in Versionsdatei schreiben
	  d) in LaTeX Versionsdatei lesen
	  e) Version ausgeben
	
	2. Notwendige Kompilierungen für das Glossar
		1. pdflatex <datei>.tex
		2. bibtex <datei>.gls
		3. pdflatex <datei>.tex
		4. pdflatex <datei>.tex
		
		Notwendige Kompilierungen für das Abkürzungsverzeichnis
		1. 
	#>
	
	$x = [string]::concat('"',$file, '.pdf','"')
	$id = (ps | select -Property ID, MainWindowTitle | where {$_.MainWindowTitle -match $x} | select -ExpandProperty ID)
	kill -ID (ps | select -Property ID, MainWindowTitle | where {$_.MainWindowTitle -match "bible.pdf"} | select -ExpandProperty ID)
	echo 'x =' $x 
	echo 'id =' $id
	# kill $x -Force
	
	# <Commandstrings> erstellen 
		$ftex = [string]::concat($file,'.tex')
		$fnls = [string]::concat($file,'.nls')
		# $fnlo = [string]::concat($file,'.nlo -s nomencl.ist -o ', $file,'.nls')
		$fnlo = [string]::concat('C:\a777360\MikTeX\miktex\bin\makeindex.exe ', $file,'.nlo -s nomencl.ist -o ', $file,'.nls')
		$fbib = [string]::concat($file,'.gls')
		$fpdf = [string]::concat($file,'.pdf')
		$fidx = [string]::concat('C:\a777360\MikTeX\miktex\bin\makeindex.exe ', $file,'.idx -g -s fomidx.ist')
		$fgls = [string]::concat($file,'.gls')
	# </Commandstrings>

	# <Kompilieren>
		write-host "######### PDFLATEX #############"
		BIN:\pdflatex.exe $ftex
		BIN:\pdflatex.exe $ftex # 2x nötig wegen Index; 1x wegen Glossar
		write-host "######### BIBTEX #############"
		BIN:\bibtex.exe $fgls
		# BIN:\pdflatex.exe $ftex
		write-host "######### PDFLATEX #############"
		BIN:\pdflatex.exe $ftex
		write-host "######### MAKEINDEX #############"
		write-host $fnlo
		& cmd.exe /c $fnlo
		# write-host BIN:\makeindex.exe $fnlo # wegen Abbrev
		# read-host
		# read-host
		# & cmd.exe /c $fidx
		# & cmd.exe /c $fnlo
		write-host "######### PDFLATEX #############"
		BIN:\pdflatex.exe $ftex # 2x wegen Glossar
		write-host "######### PDFLATEX #############"
		BIN:\pdflatex.exe $ftex # 2x wegen Glossar
	# </Kompilieren>
	# <Prozess starten>
		saps $fpdf
	# </Prozess>
 }

 function Get-OutlookInbox
 {
	 Add-type -assembly "Microsoft.Office.Interop.Outlook" | out-null	 
	 $olFolders = "Microsoft.Office.Interop.Outlook.olDefaultFolders" -as [type] 
	 $outlook = new-object -comobject outlook.application
	 $namespace = $outlook.GetNameSpace("MAPI")
	 $folder = $namespace.getDefaultFolder($olFolders::olFolderInBox)
	 $folder.items | Select-Object -Property SenderName, Subject, ReceivedTime, Importance

 }
 
  function uptime
 {
 	# shows time when machine was started
	 Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
 }
 
 
 
 
