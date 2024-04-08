#このファイルは、Railsアプリケーションのアセットパイプライン設定をカスタマイズするためのファイルです。
#通常、config/initializers/assets.rbに位置し、アセット（JavaScriptファイル、CSSファイル、画像など）のバージョニング、
#追加のアセットパスの指定、特定のアセットのプリコンパイル設定などを行います。

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += %w( main.js )

