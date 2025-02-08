Set-StrictMode -version Latest

Add-Type -AssemblyName System.Windows.Forms;

$global:SendTo = "<送り先のパスを設定してください>";
$global:Cpation = "送る";

if (-not (Test-Path $global:SendTo)) {
    $text = "送り先:${global:SendTo}にアクセスできませんでした...";

    $input = [System.Windows.Forms.MessageBox]::Show($text, $global:Cpation, "OK", "Error");
    Throw $text;
}

foreach ($arg in $args) {
    $isFolder = (Get-Item $arg) -is [System.IO.DirectoryInfo];

    try {
        if ($isFolder) {
            Copy-Item $arg -Destination $global:SendTo -Recurse -Force
        } else {
            Copy-Item $arg -Destination $global:SendTo -Force
        }
    } catch {
        $text = "${filename}のコピーに失敗しました...";

        $input = [System.Windows.Forms.MessageBox]::Show($text, $global:Cpation, "OK", "Error");
        Throw $text;
    }

    try {
        if($isFolder){
            Remove-Item $arg -Recurse -Force
        } else {
            Remove-Item $arg -Force
        }
    } catch {
        $text = "${filename}の削除に失敗しました...";

        $input = [System.Windows.Forms.MessageBox]::Show($text, $global:Cpation, "OK", "Error");
        Throw $text;
    }
}
