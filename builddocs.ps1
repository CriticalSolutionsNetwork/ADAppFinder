Import-Module .\output\ADAPPFinder\*\*.psd1
.\psDoc-master\src\psDoc.ps1 -moduleName ADAPPFinder -outputDir docs -template ".\psDoc-master\src\out-html-template.ps1"
.\psDoc-master\src\psDoc.ps1 -moduleName ADAPPFinder -outputDir ".\" -template ".\psDoc-master\src\out-markdown-template.ps1" -fileName .\README.md