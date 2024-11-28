# docker-himaplus

ひまぷらのサーバサイドのdockerプロジェクト

## 概要

himaplus([Golangプロジェクト](https://github.com/unSerori/himaplus-api))のDocker開発環境  
cloneしてスクリプト実行で、自動的にコンテナー作成して開発環境またはデプロイを行う

### 開発環境

Mac OS: Sequoia 15.1
Visual Studio Code: 1.95.2
Docker Desktop: 4.34.0
Docker Engine: 27.2.0

## 環境構築

1. Dockerをインストール[Docker Hub](https://docs.docker.com/desktop/)
2. このリポジトリをクローン

    ```bash
    git clone git@github.com:unSerori/docker-himaplus.git
    ```

3. .envファイルを作成
    - `./composes/.env`: compose.ymlでDockerfileに対する引数として使うものや、プロジェクト全体で使う変数

      ```env:./composes/.env
      TZ=Asia/Tokyo: タイムゾーン
      API_DEVELOP_HOST_PORT=4561: 開発用のGo-APIコンテナのポートをコンテナにマッピングする(ローカル環境のポートなどとの衝突の可能性)
      REV_PXY_HTTP_HOST_PORT=80: デプロイ時のNginxコンテナのHTTPポートをホストにマッピングする（ローカル環境のポートなどとの衝突の可能性）
      REV_PXY_HTTPS_HOST_PORT=443: デプロイ時のNginxコンテナのHTTPSポートをホストにマッピングする（ローカル環境のポートなどとの衝突の可能性）
      ```

    - `./services/mysql-db/.env.mysql-db`: ビルド時にmysql-db-srvコンテナーにcompose.services.service.env_fileでファイルごと与える環境変数たち

      ```env:./services/mysql-db/.env.mysql-db
      MYSQL_ROOT_PASSWORD=root: mysql_serverのルートユーザーパスワード
      MYSQL_USER=hima_user: ユーザー名
      MYSQL_PASSWORD=hima_pass: MYSQL_USERのパスワード
      MYSQL_DATABASE=hima_db: 使用するdatabase名
      ```

    - `./services/go-api/.env.go-api`: ビルド時にgo-api-srvコンテナーにCOPYされるenvファイル（`コンテナー内にコピーしたいリソースのため、go-api/内に置く`）で、Dockerを使わない場合もこれはhimaplus-apiのプロジェクトルートに必要

        ```env:./services/go-api/.env.go-api
        MYSQL_USER=hima_user: DBに接続する際のログインユーザ名
        MYSQL_PASSWORD=hima_pass: パスワード
        MYSQL_HOST=mysql-db-srv: ログイン先のDBホスト名（dockerだとサービス名）
        MYSQL_PORT=3306: ポート番号（dockerだとコンテナのポート）
        MYSQL_DATABASE=hima_db: 使用するdatabase名
        JWT_SECRET_KEY=qawsedrftgyhujikolp=: "openssl rand -base64 32"で作ったJWTトークン作成用のキー
        JWT_TOKEN_LIFETIME=315360000: JWTトークンの有効期限
        MULTIPART_IMAGE_MAX_SIZE=10485760: Multipart/form-dataの画像の制限サイズ（10MBなら10485760）
        REQ_BODY_MAX_SIZE=52428800: リクエストボディのマックスサイズ（50MBなら52428800）
        ```

    - `./services/pb-authn/.env.pb-authn`: ビルド時にpb-authn-srvコンテナにCOPYされるenvファイル（`コンテナー内にコピーしたいリソースのため、pb-authn/内に置く`）で、Dockerを使わない場合もこれはhimaplus-authnのプロジェクトルートに必要

    ```env:./services/pb-authn/.env.pb-authn
    
    ```

4. デプロイor開発用のセットアップ  
   後述（[デプロイ用のセットアップ](#デプロイ用のセットアップについて) / [開発用のセットアップ](#開発用のセットアップについて)）

5. デプロイまたは開発用のスクリプトでコンテナーを起動

    ```bash
    # 開発用の設定でビルド
    bash ./scripts-sh/develop-rebuild.sh

    # デプロイ用の設定でビルド
    bash ./scripts-sh/deploy-rebuild.sh
    ```

    その他のスクリプトファイルは[スクリプトファイルたち](#スクリプトファイルたち)

### デプロイ用のセットアップについて

#### SSL証明書発行と配置

HTTPSを使うなら、opensslやCertbot、ACMなどを使って証明書を発行する必要がある  
ドメインがないなど試験用ならopenssl（オレオレ証明書）、ドメインがあるならCertbot、AWSサービスならACMなどを使うといい  

### 開発用のセットアップについて

とくになし

### 環境に入る

1. VS Codeでアタッチ  
    VS CodeのDocker, Remote Development拡張機能をインストール、Dockerタブのコンテナーを右クリックし「Attach Visual Studio Code」でVS Codeの機能をフルに使って開発できる

1. コマンドで入りコマンドラインで作業

    ```bash
    docker exec -it himaplus_go-api /bin/bash
    ```

    またはDockerタブのコンテナーを右クリックし「Attach Shell」

### 開発用コンテナー内でSSH通信でGitHubとやりとりする方法

Attach VS Codeでインストールされるvscode-server（:VSCodeのコンテナ開発サーバー機能）のssh-agent転送機能を利用し、ホストOSで`ssh-add`しコンテナ内にSSH鍵をアジェントしてもらう

他にもコンテナ内でssh-keygenする, 登録済みのホストの鍵を手動またはvolumesで追加などがある

## スクリプトファイルたち

コンテナーを建てたり壊したりする用のスクリプトファイルの説明  
`./scripts-**/`直下に置いてある

- balus.sh: コンテナーたちを破壊する
- deploy-*: go-apiをデプロイ用に建てる
- develop-*: go-apiを開発用に建てる
- *-destroy: コンテナーたちを破棄する
- *-pause.sh: コンテナーたちを停止する
- *-reboot.sh: コンテナーたちを再起動する
- *-rebuild.sh: コンテナーたちを再ビルド&起動する
- *-resume.sh: コンテナーたちを再開する
- gen_key.sh: SSL鍵を作る
