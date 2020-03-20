const path = require('path');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
  entry: './src/fpJS.coffee',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [ 'coffee-loader' ]
      }
    ]
  },
  resolve: {
    modules: [path.resolve(__dirname, 'src/'), 'node_modules']
  },
  plugins: [new CleanWebpackPlugin()]
};
