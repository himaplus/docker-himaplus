# docker-himaplus

ひまぷらのサーバサイドのdockerプロジェクト

1. .envファイルを作成
  - `./composes/.env`: compose.ymlでDockerfileに対する引数として使うものや、プロジェクト全体で使う変数

      ```env:./composes/.env
      TZ=タイムゾーン: Asia/Tokyo
      API_DEVELOP_HOST_PORT=開発用のGo-APIコンテナのポートをコンテナにマッピングする(ローカル環境のポートなどとの衝突の可能性): 4561
      API_DEPLOY_HOST_PORT=デプロイ用のGo-APIコンテナのポートをコンテナにマッピングする(ローカル環境のポートなどとの衝突の可能性): 4561
      ```

  - `./services/mysql-db/.env.mysql-db`: ビルド時にmysql-db-srvコンテナーにcompose.services.service.env_fileでファイルごと与える環境変数たち

      ```env:./services/mysql-db/.env.mysql-db
      MYSQL_ROOT_PASSWORD=mysql_serverのルートユーザーパスワード: root
      MYSQL_USER=ユーザー名: hima_user
      MYSQL_PASSWORD=MYSQL_USERのパスワード: hima_pass
      MYSQL_DATABASE=使用するdatabase名: hima_db
      ```

  - `./services/go-api/.env.go-api`: ビルド時にgo-api-srvコンテナーにCOPYされるenvファイル（`コンテナー内にコピーしたいリソースのため、go-api/内に置く`）で、Dockerを使わない場合もこれはjuninry-apiのプロジェクトルートに必要

      ```env:./services/go-api/.env.go-api
      MYSQL_USER=DBに接続する際のログインユーザ名: hima_user
      MYSQL_PASSWORD=パスワード: hima_pass
      MYSQL_HOST=ログイン先のDBホスト名（dockerだとサービス名）: mysql-db-srv
      MYSQL_PORT=ポート番号（dockerだとコンテナのポート）: 3306
      MYSQL_DATABASE=使用するdatabase名: hima_db
      JWT_SECRET_KEY="openssl rand -base64 32"で作ったJWTトークン作成用のキー
      JWT_TOKEN_LIFETIME=JWTトークンの有効期限: 315360000
      MULTIPART_IMAGE_MAX_SIZE=Multipart/form-dataの画像の制限サイズ（10MBなら10485760）: 10485760
      REQ_BODY_MAX_SIZE=リクエストボディのマックスサイズ（50MBなら52428800）: 52428800
      ```