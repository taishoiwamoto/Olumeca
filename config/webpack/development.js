//このファイルは、Webpackの設定ファイルの一部として使われるJavaScriptファイルです。
//Webpackは、JavaScriptのモジュールバンドラーであり、多数の依存関係を持つJavaScriptファイルを単一のファイル（または少数のファイル）に
//まとめるために使用されます。このプロセスは、ブラウザの読み込み時間を短縮し、ウェブアプリケーションのパフォーマンスを向上させるのに役立ちます。

// 環境変数NODE_ENVを設定します。もし何も設定されていなければ、'development'をデフォルト値として使用します。
// これにより、開発環境と本番環境のビルド設定を区別することができます。
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

// './environment'というパスからWebpackの環境設定をインポートします。
// このファイルではWebpackの各種設定やプラグインを定義し、ビルドプロセスの挙動をカスタマイズできます。
const environment = require('./environment')

// 最終的なWebpack設定オブジェクトをエクスポートします。
// 'toWebpackConfig'メソッドは、環境設定オブジェクトから実際にWebpackが使用する設定オブジェクトを生成します。
// これにより、定義したカスタマイズがWebpackのビルドプロセスに適用されます。
module.exports = environment.toWebpackConfig()
