# importmap.rbは、JavaScriptモジュールの依存関係を管理するための設定ファイル
# JavaScriptの管理を簡素化するのに役立ちます。

# Pin npm packages by running ./bin/importmap
# このコマンドでnpmパッケージをピン留めします。

# アプリケーションのメインJavaScriptファイルをピン留めし、事前にロードします。
pin "application", preload: true

# Turboを使用するための設定。turbo.min.jsをピン留めし、事前にロードします。
# Turboは、Hotwireフレームワークの一部で、Railsアプリケーション（または他のWebアプリケーションフレームワーク）で使用されるJavaScriptライブラリです
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

# Stimulusフレームワークの特定のバージョンを外部リンクからピン留めします。
# Stimulusは、Basecampによって開発された、モダンなウェブアプリケーションのための軽量なJavaScriptフレームワークです。
# Hotwireスタックの一部として、Turboと一緒にしばしば使用されますが、その目的と使用方法は、HTML主導のアプローチを促進し、
# ウェブアプリケーションに最小限のJavaScriptを使用してインタラクティビティを追加することに重点を置いています
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"

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

# Stimulusを使ったネストされたフォームの管理を可能にするライブラリをピン留めします。
# このライブラリは、複雑なフォーム内での子要素（ネストされたフォーム）の動的な追加や削除をサポートします。
# これにより、ユーザーはインターフェース上で直感的に複数の関連するフォーム要素を操作できるようになります。
# リンクはこのライブラリの最新バージョンを指し示しており、常に最新の機能を利用できるようになっています。
pin "stimulus-rails-nested-form", to: "https://ga.jspm.io/npm:stimulus-rails-nested-form@4.1.0/dist/stimulus-rails-nested-form.mjs"
