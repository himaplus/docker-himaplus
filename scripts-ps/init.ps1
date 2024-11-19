# 初期化処理
# 変数の読み込みとディレクトリ移動

# 変数を読み込み

# env.ini ファイルのパス
$envFile = ".\env.ini"
# ファイルが存在するか確認
if (-Not (Test-Path $envFile)) {
    Write-Error "env.ini is not found: $envFile"
    exit
}
# ファイルの内容を行ごとに読み込む
Get-Content $envFile | ForEach-Object {
    # コメント行と空行をスキップ
    if ($_ -match "^\s*#") { return }
    if ($_.Trim() -eq "") { return }

    # キーと値を '=' で分割
    $parts = $_ -split "=", 2
    if ($parts.Length -eq 2) {
        # 変数を設定
        $key = $parts[0].Trim()
        $value = $parts[1].Trim()
        [System.Environment]::SetEnvironmentVariable($key, $value, "Process")
    }
}

# composeディレクトリに移動
# Set-Location ..\compose -ErrorAction Stop

# if ($LASTEXITCODE -ne 0) {
#     Write-Host "Failure CD command."
#     exit 1
# }

$targetPath ="..\compose"

# パスが存在するか確認
if (Test-Path $targetPath) {
    # 指定されたパスに移動
    Set-Location $targetPath -ErrorAction Stop

    # エラーが発生した場合の処理
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failure CD command."
        exit 1
    }
} else {
    Write-Host "指定されたパスが存在しません: $targetPath"
    exit 1
}

