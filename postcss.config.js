// postcss.config.js ファイルでは、PostCSS の設定を行うことができます。環境に応じて条件付きでプラグインを入れたい場合に便利です

module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
