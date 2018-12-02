const path = require('path')

module.exports = {
  mode: process.env.NODE_ENV,
  entry: './lib/es6_global/src/prod.js',
  output: {
    path: path.join(__dirname, 'docs', 'assets'),
    filename: 'bundle.js',
  },
  devServer: {
    contentBase: path.join(__dirname, 'docs'),
    stats: 'minimal',
  },
  stats: 'minimal',
  resolve: {
    modules: ['node_modules'],
  },
}
