var path = require('path')
var WebpackNotifierPlugin = require('webpack-notifier')
var HtmlWebpackPlugin =  require('html-webpack-plugin')

module.exports = {

  entry: [
    'babel-polyfill',
    './src'
  ],

  plugins: [
    new WebpackNotifierPlugin({title: 'munro-map'}),
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'src/index.html'
    })
  ],

  devtool: 'source-map',

  output: {
    path: path.join(__dirname, './public'),
    filename: 'bundle.js'
  },

  resolve: {
    extensions: ['', '.js', '.jsx']
  },

  resolveLoader: {
    root: path.join(__dirname, 'node_modules')
  },

  module: {

    // preLoaders: [
    //   { test: /\.js$/, loader: "eslint-loader", include: __dirname }
    // ],

    loaders: [
      { test: /\.js$/, loader: 'babel-loader', exclude: [path.resolve(__dirname, "node_modules")] },
      { test: /\.css$/, loader: 'style!css' },
      { test: /\.(ttf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/, loader: "file" },
      { test: /\.png$/, loader: "file" }
    ]
  },

  eslint: {
    failOnError: true
  }
}
