// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// importmapをconfig/importmap.rbで設定してください。詳しくはこちらをご覧ください: https://github.com/rails/importmap-rails
// Importmapを使用すると、JavaScriptのモジュールをSprocketsやWebpackを使わずにRailsで簡単に管理できるようになります。
import Rails from "@rails/ujs"
// Rails UJSを起動します。RailsのUnobtrusive JavaScript (UJS)は、Railsアプリケーション内のJavaScriptを簡単に扱うためのライブラリです。
Rails.start()

// Turboをインポートして起動します。Turboは、Hotwireの一部であり、ページ遷移の高速化や部分的なページ更新を行うライブラリです。
import "@hotwired/turbo-rails"

// Stimulusコントローラーをインポートします。Stimulusは、HTML要素にJavaScriptの振る舞いを結びつけるためのフレームワークです。
// この行は、app/javascript/controllersディレクトリ内のすべてのStimulusコントローラーを自動的にロードして、アプリケーションで使用可能にします。
import "controllers"
