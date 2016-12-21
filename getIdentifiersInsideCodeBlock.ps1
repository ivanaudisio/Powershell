$path = "C:\Users\ivan.audisio\Desktop\script.txt"
$codeBlock = "node"
$identifier = "checkpoint"

$regex = [regex]"(?:{|}|\bcheckpoint\b|\bnode\b|\btimeout\b|\bparallel\b|\binput\b|\bwhile\b|\b$identifier\b)"
$content = Get-Content $path
$string = ""
$lineNumber = 0
$countOpenCB = 0
$identifiers = ""
$output = ""

foreach($line in $content) {
    $lineNumber++
    if ($regex.Matches($line)) {
        $matches = $regex.Matches($line);
        if ($matches) {
            foreach($match in $matches) {
                if ($allIdentifiers -like "*$codeBlock*" -And $match.value -eq "{") {
                    $countOpenCB++
                }
                elseif($allIdentifiers -like "*$codeBlock*" -And  $match.value -eq "}") {
                    $countOpenCB--
                    if ($countOpenCB -eq 0) {
                        $allIdentifiers = ""
                    }
                }
                else {
                    $allIdentifiers += $match.value + ";"
                }
                if ($match.Value -eq $identifier) {
                    if ($countOpenCB -gt 0) {

                        if ($allIdentifiers -like "*$codeBlock*") {
                            $output += $match.value + " on line " + $lineNumber + " is inside code Block " + $codeBlock + "`r`n"
                        }
                    }
                }
            }
        }
    }
}
Write-Output $output
