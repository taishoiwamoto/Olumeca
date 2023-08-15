const path = require('path');

module.exports = {
  entry: {
    main: './src/index.js'
  },

  // 出力設定
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },

  // モジュールの設定
  module: {
    rules: [
      // ここにローダーやその他のモジュール設定を追加できます。
    ]
  },

  // プラグインの設定
  plugins: [
    // ここにプラグインのインスタンスを追加できます。
  ]
};
