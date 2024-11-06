# 初期化処理
# 変数の読み込みとディレクトリ移動

# 変数を読み込み
.\env.ini


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

