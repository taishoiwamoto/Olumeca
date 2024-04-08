#このファイルは、Ruby on Railsアプリケーションで使用されるJavaScriptの依存関係を管理するためのImportmap設定スクリプトです。
#Importmapは、ブラウザがサポートするネイティブのJavaScriptモジュールシステムを使用して、
#npmパッケージや他のJavaScriptファイルを直接Webページにインポートするための仕組みを提供します。
#これにより、JavaScriptのバンドラーやコンパイラーを使用せずに、モダンなJavaScript開発が可能になります。
# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", preload: true
pin "stimulus-rails-nested-form", to: "https://ga.jspm.io/npm:stimulus-rails-nested-form@4.1.0/dist/stimulus-rails-nested-form.mjs"
