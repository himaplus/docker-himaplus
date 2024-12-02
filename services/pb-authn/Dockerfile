# 開発用やビルド用の共通ステージ

# Stage0: goの入ったイメージ
FROM golang:1.23-bookworm AS base

# aptでパッケージリストの更新とgitインストール
RUN apt-get update && \
    apt-get install -y git

# 開発用のステージ

# Stage1: 開発環境に必要なツールとソースを入れるベースイメージ
FROM base AS develop

# 作業ディレクトリ
WORKDIR /root/copy

# 必要なものインストール
RUN \
    # ssh通信のためのクライアント
    apt-get install -y git openssh-client && \
    # デバッガインストール
    go install github.com/go-delve/delve/cmd/dlv@latest

# 必要なファイルのコピー
COPY .env.pb-authn .env

# httpポートの公開 pbはこのポートを次のために利用する[静的コンテンツの提供, スーパーユーザダッシュボード, REST-ish API]
EXPOSE 8090

# 実行用のスクリプトをコピー
COPY ./init.sh .
# 改行コードを揃えて、権限も変更
RUN sed -i -e 's/\r//g' ./init.sh && \
    chmod +x ./init.sh

# スクリプトで起動
ENTRYPOINT [ "./init.sh" ]

# デプロイ用のステージ

# Stage1: ビルドのためのgoが入ったイメージ
FROM base AS deploy-builder

# 作業ディレクトリ
WORKDIR /root/

# ソースコードのクローン
RUN git clone https://github.com/unSerori/himaplus-authn.git -b main
# 必要なリソースを渡す
#COPY ./share/hoge/ ./himaplus-authn/**/hoge/
# ビルド処理
RUN \
    # 移動
    cd ./himaplus-authn &&\
    # ビルド なお、deploy-builderイメージにgo実行環境が入ってるのでビルドツールのDLは不要
    go build -o himaplus-pb-authn

# Stage2: 公開用のための軽量debian
FROM debian:bookworm-slim AS deploy-final

# 作業ディレクトリ
WORKDIR /usr/local/bin/

# 成果物のコピー
COPY --from=deploy-builder /root/himaplus-authn/himaplus-pb-authn himaplus-pb-authn
# 実行に必要なファイルのコピー
COPY .env.pb-authn .env

# httpポートの公開 pbはこのポートを次のために利用する[静的コンテンツの提供/*, スーパーユーザダッシュボード/_/, REST-ish API]
EXPOSE 8090

# ビルド済みの実行ファイルを本番環境でCMD起動
ENTRYPOINT [ "himaplus-pb-authn" ]
