const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')

module.exports = {
  mode: process.env.NODE_ENV,
  entry: './lib/js/src/web.js',
  output: {
    path: path.join(__dirname, 'docs', 'assets'),
    filename: 'bundle.js',
    publicPath: '/assets',
  },
  devServer: {
    contentBase: path.join(__dirname, 'docs'),
    stats: 'minimal',
  },
  stats: 'minimal',
  resolve: {
    modules: ['node_modules'],
  },
  plugins: [new CopyWebpackPlugin([{ from: 'assets', to: '.' }])],
}
