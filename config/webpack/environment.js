//このファイルは、RailsアプリケーションでWebpackerを使用する際の基本的なWebpack設定をエクスポートするためのものです。
//Webpackerは、RailsアプリケーションにWebpackを簡単に統合し、JavaScriptやその他のフロントエンドアセットを管理するためのライブラリです。

// '@rails/webpacker'パッケージから'environment'をインポートします。
// この'environment'オブジェクトは、Webpackerが提供する一連の設定やツールを含んでいます。
// これにより、RailsアプリケーションのWebpack設定を簡単に管理できるようになります。
const { environment } = require('@rails/webpacker')

// 'environment'オブジェクトをそのままエクスポートします。
// これにより、Railsアプリケーションの他の場所でこの設定を参照したり、拡張したりすることができます。
// 具体的には、このオブジェクトをベースとしてカスタムのWebpack設定を追加したり、
// 独自のローダーやプラグインを組み込むことが可能になります。
module.exports = environment
