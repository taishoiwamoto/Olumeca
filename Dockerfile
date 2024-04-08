# このDockerfileは、Rubyベースのイメージを使用してOlumecaアプリケーションを実行するための環境を設定するためのものです。
# Dockerは、アプリケーションとその依存関係をコンテナという単位でパッケージ化し、環境に依存しない形でアプリケーションを実行するためのプラットフォームです。
# このDockerfileを使用することで、Olumecaアプリケーションを異なる環境でも一貫して実行することが可能になります。

# Rubyバージョン3.1.2をベースにしたイメージを使用する指定
FROM ruby:3.1.2 as base

# '/Olumeca'ディレクトリを作成し、以後の作業ディレクトリとして設定
WORKDIR /Olumeca

# システム依存関係のインストール。必要なパッケージをapt-getを通じてインストール
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    sudo \
    postgresql \
    postgresql-contrib \
    curl \
    libvips \
    libpq5 \
    openssl \
    tzdata

# GemfileとGemfile.lockをコピーし、Rubyの依存関係をインストール
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

# アプリケーション起動時に実行されるスクリプトをコンテナに追加し、実行可能に設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
