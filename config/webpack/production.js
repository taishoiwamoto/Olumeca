//このファイルは、Webpackの設定を定義してエクスポートするJavaScriptファイルで、特に本番環境用のWebpack設定を指定しています。

// 環境変数NODE_ENVを設定します。もしNODE_ENVが未定義なら、'production'をデフォルト値として設定します。
// これは、本番環境でのビルドが最適化され、デバッグ情報が削除され、アプリケーションが高速に実行されるようにするためです。
process.env.NODE_ENV = process.env.NODE_ENV || 'production'

// './environment'ファイルからWebpackの設定をインポートします。
// この設定ファイルは、Webpackの様々な設定（ローダー、プラグインなど）をカスタマイズするために使用されます。
const environment = require('./environment')

// environmentオブジェクトのtoWebpackConfigメソッドを使用して、Webpackの設定オブジェクトを生成し、エクスポートします。
// これにより、Webpackはこの設定を使用してアプリケーションのアセットを適切にバンドルできるようになります。
module.exports = environment.toWebpackConfig()
