#!/bin/bash

# コンテナの再起動を行うが、イメージの再構築や更新された設定は反映させない

# スクリプトの実行場所を取得
$sh_dir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
Set-Location $sh_dir -ErrorAction Stop

# 再起動（停止 + 再開）
# deploy-pause.ps1 と deploy-resume.ps1 を実行
if (Test-Path "$sh_dir\develop-pause.ps1") {
    & "$sh_dir\develop-pause.ps1"
} else {
    Write-Host "develop-pause.ps1 が見つかりません: $sh_dir\develop-pause.ps1"
    exit 1
}

if (Test-Path "$sh_dir\develop-resume.ps1") {
    & "$sh_dir\develop-resume.ps1"
} else {
    Write-Host "develop-resume.ps1 が見つかりません: $sh_dir\develop-resume.ps1"
    exit 1
}
