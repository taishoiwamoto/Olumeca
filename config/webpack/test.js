// Webpackにおける環境設定を扱うJavaScriptファイルの一部です。

// 現在の環境が定義されていない場合、デフォルトで'development'という値を設定する。
// これにより、特に指定がない限り、開発モードでのビルドが行われることを意味します。
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

// 環境設定を扱うモジュールをインポートする。
// './environment'ファイルはプロジェクト特有のWebpack設定を含み、
// この設定はビルド時の動作や最適化に影響を与えます。
const environment = require('./environment')

// Webpackの設定を環境設定に基づいて生成し、エクスポートする。
// `toWebpackConfig`メソッドは、上記でインポートした環境設定を使用して、
// 実行時の環境に応じたWebpackの設定オブジェクトを生成します。
// この設定はWebpackによって使用され、プロジェクトのビルドプロセスを定義します。
module.exports = environment.toWebpackConfig()
