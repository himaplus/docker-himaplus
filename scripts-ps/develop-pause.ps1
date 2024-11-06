#!/bin/bash

# サービス(コンテナ)たちを停止

# CDに移動&初期化
$sh_dir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
Set-Location $sh_dir -ErrorAction Stop

# init.ps1 を実行
if (Test-Path "$sh_dir\init.ps1") {
    . "$sh_dir\init.ps1"
} else {
    Write-Host "init.ps1 が見つかりません: $sh_dir\init.ps1"
    exit 1
}

# develop 停止
$env:DOCKER_BUILDKIT = "1"
docker compose -p  "${env:PROJECT_NAME}_deploy"  stop
