const config = {
  mode: production,
  entry: _dirname + '/src/index.ts',
  output: {
    path: _dirname + '/dist',
    filename: 'demo.min.js'
  },
  module: {
    rules: [{
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.ts$/,
        use: ['ts-loader']
      },
    ]
  }
}

modules.exports = (env, args) {
  return config;
}
