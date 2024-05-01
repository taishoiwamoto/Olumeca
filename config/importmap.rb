# importmap.rbは、JavaScriptモジュールの依存関係を管理するための設定ファイル
# JavaScriptの管理を簡素化するのに役立ちます。

# Pin npm packages by running ./bin/importmap
# このコマンドでnpmパッケージをピン留めします。

# アプリケーションのメインJavaScriptファイルをピン留めし、事前にロードします。
pin "application", preload: true

# Turboを使用するための設定。turbo.min.jsをピン留めし、事前にロードします。
# Turboは、Hotwireフレームワークの一部で、Railsアプリケーション（または他のWebアプリケーションフレームワーク）で使用されるJavaScriptライブラリです
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# Stimulus Loadingを使用するための設定。stimulus-loading.jsをピン留めし、事前にロードします。
# Stimulus Loadingは、ページの特定の部分が読み込まれている間にローディングインジケータを表示する機能を提供します。
# これにより、ユーザーはデータがまだロード中であることを視覚的に理解でき、より良いユーザーエクスペリエンスを提供します。
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# app/javascript/controllersディレクトリ内のすべてのJavaScriptファイルを「controllers」としてピン留めします。
# この操作により、Stimulusフレームワークで使用されるコントローラーファイルがモジュールとして利用可能になります。
# Import Mapsを使用してこれらのコントローラーモジュールを管理することで、JavaScriptのバンドリングが不要になり、
# ブラウザが直接これらのモジュールを効率的にロードできるようになります。
pin_all_from "app/javascript/controllers", under: "controllers"

# Rails UJSをピン留めし、事前にロードします。Rails UJS (Unobtrusive JavaScript) は、
# RailsアプリケーションでAjax、フォーム送信、リンクによるHTTPメソッドの操作を簡単に実装するためのライブラリです。
# これにより、JavaScriptを使ったリッチなインタラクションが簡単にRailsアプリケーションに組み込めます。
pin "@rails/ujs", preload: true