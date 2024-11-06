# 最初の起動や更新の反映に使う
# 既存のイメージやキャッシュを破棄してビルド&起動し直す

# スクリプトのディレクトリを取得
$sh_dir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -Path $sh_dir

# init.ps1を実行
.\init.ps1

# 破棄処理
docker-compose -p "${env:PROJECT_NAME}_deploy" down --rmi all --remove-orphans --volumes --timeout 15


# キャッシュなしでビルド
$env:DOCKER_BUILDKIT=1
docker-compose -p "${env:PROJECT_NAME}_deploy" -f "compose.yml" -f "compose.develop.yml" build --no-cache


# 起動
$env:DOCKER_BUILDKIT=1
docker-compose -p "${env:PROJECT_NAME}_deploy" -f "compose.yml" -f "compose.develop.yml" up -d


# 環境変数DOCKER_BUILDKITを設定する部分です。1を設定することで、Docker BuildKitを有効にする。BuildKitは、Dockerイメージのビルドをより効率的に行うための新しいビルドエンジンで、並列ビルドやキャッシュの最適化などの機能を提供。
# docker compose:はDocker Composeコマンドを呼び出しています。Docker Composeは、複数のDockerコンテナを定義し、一括で管理するためのツールです。
#${PROJECT_NAME}は、事前に設定されている環境変数で、実行時にその値が使用されます。これにより、複数のプロジェクトを同時に管理することができます。特定のデプロイメント用の名前空間が作成されます。
# -fオプションは、使用するDocker Composeファイルを指定します。ここでは、compose.ymlとcompose.deploy.ymlの2つのファイルが指定されています。
# upコマンドは、指定されたComposeファイルに基づいてサービスを起動します。-dオプションを付けることで、コンテナをバックグラウンドで実行します。
