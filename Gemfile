source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Rubyのバージョン指定
ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
# [デフォルト] Railsのバージョン指定、安定性と最新機能のバランスを考慮
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
# [デフォルト] Railsのアセットパイプライン（CSS・JavaScriptの管理）用
# 開発者はCSSやJavaScriptのファイルを効率的に管理できるようになり、Webアプリケーションのパフォーマンスを向上させることができます。
# Railsのアセットパイプラインは、Webアプリケーションで使用されるCSSやJavaScriptファイルなどのアセット（資源）を管理し、効率的にブラウザに配信する仕組みです。このシステムは、複数のファイルを一つにまとめたり（結合）、ファイルサイズを小さくするために圧縮したり（圧縮）、ファイルにユニークな名前をつけてキャッシュ効果を最大化する（フィンガープリンティング）などの処理を自動で行います。
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record

# Use the Puma web server [https://github.com/puma/puma]
# [デフォルト] 高性能なWebサーバー、Ruby/Railsアプリケーション用
# Pumaは、高速で並列処理に優れたアプリケーションサーバーです。Ruby on Railsのアプリケーションを動かすために利用され、ブラウザや他のクライアントからのHTTPリクエストを受け取り、適切なRailsアプリケーションのコードを実行してレスポンスを返します。Pumaはマルチスレッドをサポートしており、同時に多くのリクエストを処理する能力があるため、特に並列処理を多用するアプリケーションに適しています。
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
# [デフォルト] JavaScriptのモジュールを簡単に扱うためのライブラリ
# Import Mapは、JavaScriptモジュールをブラウザが直接読み込めるようにマッピングするための仕組みです。通常、JavaScriptのモジュールを使うためには、Webpackなどのツールを使って複数のファイルを一つにまとめたり、トランスパイル（コードをブラウザが解釈しやすい形に変換する処理）を行う必要があります。しかし、Import Mapを使うと、これらの手順なしでブラウザが直接JavaScriptモジュールを読み込むことができるようになります。
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# [デフォルト] Turboは、Hotwireの一部であり、Webページの速度を向上させるためのライブラリです。
# ページのナビゲーションと部分的なページ更新を高速化するためのライブラリです。Turboを使用する主な目的は、全ページのリロードを必要とせずに、Webページの一部分だけを更新することで、アプリケーションのレスポンス時間を短縮し、パフォーマンスを向上させることです。Turboには以下の三つの主要な機能があります：
# Turbo Drive：ページ間のナビゲーションを高速化します。全ページリロードを避け、ページの特定の部分だけを交換することで高速なページ遷移を実現します。
# Turbo Frames：ページ内の特定のセクション（フレーム）のみを更新します。これにより、ページの一部だけを非同期で更新することができます。
# Turbo Streams：WebSocketを介してリアルタイムにページの更新を行います。サーバーからのプッシュにより、ページの特定の部分がリアルタイムで更新されることが可能です。
gem "turbo-rails", "~> 1.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# [デフォルト] 小規模なJavaScriptフレームワーク、Hotwireの一部
# Stimulusは、HTMLに少量のJavaScriptを「接続」することによって、既存のHTML上で動作する軽量なフレームワークです。Stimulusは、主にDOM（Document Object Model）要素の操作とイベントハンドリングを簡単にすることを目的としています。このフレームワークは、HTML要素に対して明確な接続点（コントローラー）を提供し、これを通じてユーザーのインタラクションに反応する小規模なJavaScriptの動作を実装します。Stimulusは、Turboと組み合わせて使用されることが多く、Turboによって動的に変更されたページの部分に対して、振る舞いを追加する役割を果たします。
# TurboとStimulusは、一緒に使用されることでRailsアプリケーションにリッチなインタラクティビティと高速なレスポンスをもたらします。Turboがページの高速な部分更新を担い、Stimulusはその更新されたページの要素に対して具体的なJavaScriptの振る舞いを付加します。これにより、開発者はサーバーサイドのロジックとクライアントサイドのインタラクションの間でスムーズに作業できるようになります。
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# [デフォルト] JSON形式のAPIを簡単に作成できる
# JbuilderはRuby on Railsのアプリケーションで、JSON形式のデータを簡単に作成するためのツールです。JSON（JavaScript Object Notation）は、Web上でデータを交換する際に広く利用されるフォーマットで、その構造はキーと値のペアで構成されます。Jbuilderを使うと、このJSONデータを効率的に組み立てることができ、特にAPI（Application Programming Interface）を開発する際に便利です。
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# [デフォルト] パスワードのセキュリティ機能を提供
# bcryptは、パスワードを安全に扱うためのRubyライブラリです。このgemを使用することで、パスワードを安全にハッシュ化して保存することができます。ハッシュ化とは、元のデータ（この場合はパスワード）を一方向の関数を通して変換し、元に戻せないデータにする処理のことを指します。
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# [デフォルト] Windows環境のためのタイムゾーンデータ
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
# [デフォルト] アプリの起動時間を短縮するためのキャッシング
# Bootsnapは、Ruby on Railsアプリケーションの起動時間を短縮するためのライブラリです。このGemは、アプリケーションのロードプロセス中に発生するいくつかの時間消費操作を最適化することで、起動速度を向上させます。
gem "bootsnap", require: false

#  [デフォルト] RailsのアセットコンパイルにWebpackを使用
# Ruby on Rails で JavaScript を使用してフロントエンド開発を行うために必要な一連のまとまりを実装できる gem パッケージです。
# Webpackerは、Ruby on RailsプロジェクトでWebpackを簡単に使用できるようにするためのライブラリ（gem）です。Webpackはフロントエンドのアセット（JavaScript、CSS、画像など）を管理し、それらをバンドル（一つにまとめる）や最適化するためのツールです。Webpackerを使うことで、Railsの開発者はWebpackの強力な機能を簡単にRailsアプリケーションに統合できます。
gem 'webpacker'

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# 開発・テスト環境でのみ使用するSQLite3
group :development, :test do
  gem "sqlite3", "~> 1.4"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # デバッグ用のツール
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  # 環境変数を管理
  gem 'dotenv-rails'
  # コンソールでの出力を整形する
  gem 'hirb'
end

# 開発環境専用のコンソールツール
group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

# テスト環境で使用するシステムテストライブラリ
group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

#group :production do
  #gem 'pg'
#end

# 本番環境でのPostgreSQLの設定
gem 'pg', '>=0.18', '< 2.0'

# 認証機能の提供
# [検討事項] 実装スピード、セキュリティー
gem 'devise'

# reCAPTCHAのサポートを提供
# [検討事項] セキュリティー
gem 'recaptcha', require: 'recaptcha/rails'

# フォントアイコンの使用
# [検討事項] UIUX改善
gem "font-awesome-sass", "~> 6.4.2"

# ページネーション機能の提供
# 長くなってしまったWebページを分割するものです。
# [検討事項] UIUX改善
gem 'kaminari'

# 画像処理用のライブラリ
# Image Processingは、Rubyで画像処理を行うためのライブラリです。このgemは、MiniMagickやVipsなどの下位の画像処理ライブラリに対するラッパーとして機能し、画像のリサイズ、フォーマット変更、品質調整などの一般的な画像操作を簡単に行うことができます。
# Active Storageを使用する際に画像処理のために推奨されるgemです。Active Storageは、Railsアプリケーションでファイルのアップロードを管理するためのフレームワークです。これを使用することで、さまざまなストレージサービス（Amazon S3、Google Cloud Storage、Microsoft Azure Storageなど）にファイルをアップロードし、管理することができます。
# gem "image_processing" と gem "cloudinary" を組み合わせて使うことで、アップロード時に基本的な画像処理をローカルで行い、必要に応じてクラウド上で高度な画像処理を行うことができます。
# [検討事項] 実装スピード
gem "image_processing", ">= 1.2"

# 画像のアップロードと管理ができるクラウドサービス
# 画像や動画の変換、アップロード、管理を簡単に実行可能
# [検討事項] 実装スピード、高度な画像処理
gem "cloudinary"
