const path = require('path');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
  entry: './src/index.coffee',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist')
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [
          {
            loader: 'coffee-loader',
            options: {
              transpile: {
                presets: ['@babel/preset-env']
              }
            }
          }
        ],
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    modules: [path.resolve(__dirname, 'src/fpjs'), 'node_modules']
  },
  plugins: [new CleanWebpackPlugin()]
};
