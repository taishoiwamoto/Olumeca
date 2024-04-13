// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// config/importmap.rb でのインポートマップ設定に基づき、必要なライブラリをインポートします。
// 詳細は https://github.com/rails/importmap-rails を参照してください。
import Rails from "@rails/ujs"
// Rails UJS（Unobtrusive JavaScript）を起動します。
// Rails UJSは、RailsアプリケーションでJavaScriptをより使いやすくするためのヘルパー機能を提供します。
Rails.start()

// Turboリンクの次世代バージョンであるHotwire Turboをインポートします。
// これにより、ページの部分的な更新やSPA(Single Page Application)のような振る舞いが容易に実現します。
import "@hotwired/turbo-rails"
// StimulusJSのコントローラーファイルをインポートします。
// controllersディレクトリ下のJavaScriptファイルを自動的に読み込み、Stimulusを通じてページ上のDOM要素を簡単に操作できます。
import "controllers"
