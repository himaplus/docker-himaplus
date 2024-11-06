#!/bin/bash

# stopで停止していたコンテナたちを開始

# スクリプトの実行場所を取得
$sh_dir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
Set-Location $sh_dir -ErrorAction Stop

# init.ps1 を実行
if (Test-Path "$sh_dir\init.ps1") {
    . "$sh_dir\init.ps1"
} else {
    Write-Host "init.ps1 が見つかりません: $sh_dir\init.ps1"
    exit 1
}

# 開始
$env:DOCKER_BUILDKIT = "1"
docker compose -p  "${env:PROJECT_NAME}_deploy"  start







