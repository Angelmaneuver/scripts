Set-StrictMode -version Latest

Add-Type -AssemblyName System.Windows.Forms;

$global:ScriptName = (Split-Path(&{$myInvocation.ScriptName}) -Leaf);
$global:Cpation    = $global:ScriptName;
$global:Current    = Split-Path(&{$myInvocation.ScriptName});
$global:Original   = $global:Current + "\original";
$global:Converted  = $global:Current + "\converted";
$global:IrfanView  = "<IrfanViewのパスを設定してください>"
$global:Height     = 640;
$global:Width      = 900;

if (-not (Test-Path $global:Original)) {
    $text = "変換元フォルダ:${global:Original}にアクセスできませんでした...";

    [System.Windows.Forms.MessageBox]::Show($text, $global:Cpation, "OK", "Error");
    Throw $text;
}

if (-not (Test-Path $global:Converted)) {
    $text = "変換先フォルダ:${global:Converted}にアクセスできませんでした...";

    [System.Windows.Forms.MessageBox]::Show($text, $global:Cpation, "OK", "Error");
    Throw $text;
}

Write-Host ;
Write-Host " " $global:ScriptName "を実行する場合は、""Y""を入力してください。";

$confirm = Read-Host ">";

if(-not ("Y" -ieq $confirm) -and -not ("y" -ieq $confirm)){

    Write-Host " " $confirm "が入力されました、処理を終了します...";
    exit 0;
}

Write-Host ;
Write-Host " " $global:ScriptName "開始:" (Get-Date);

foreach($file in Get-ChildItem -Path $global:Original){

    $name = $file.BaseName;
    $path = $file.FullName;

    if(".gitkeep" -eq $file) {
        continue;
    }

    for($i=0; $i -lt 16; $i++){

        $x = $global:Width * $i;

        $y = $i + 1;
        $add_name = "_1x" + $y.ToString("00");

        $crop_path = $global:Converted + "\" + $name + $add_name + $file.extension;

        # Start-Process -FilePath "$global:IrfanView" -ArgumentList "$global:Converted\$file /crop=($x, 0, $global:Width, $global:Height) /jpgq=100 /convert=$crop_path"
        Start-Process shell:AppsFolder\30067IrfanSkiljanIrfanVie.IrfanView64_psgec73n2n7ne!IrfanView64App -ArgumentList "$path /rotate_r /jpgq=100 /crop=($x, 0, $global:Width, $global:Height) /convert=$crop_path"
    }
}

Write-Host " " $global:ScriptName "終了:" (Get-Date);
Exit 0;
