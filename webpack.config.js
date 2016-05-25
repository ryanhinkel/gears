var webpack = require('webpack');
var UglifyJsPlugin = webpack.optimize.UglifyJsPlugin;

var env = process.env.WEBPACK_ENV
var name = 'gear_rotate'

config = {}
config.module =  {
    loaders: [
        { test: /\.coffee$/, loader: "coffee-loader" }
    ]
}
config.resolve = {
    extensions: ["", ".webpack.js", ".web.js", ".js", ".js.coffee"]
}

// Build target
if (env === 'build') {
    config.entry = "./src/main.js.coffee";
    config.output = {
        path: __dirname + '/dist/',
        filename: name + '.js' }

    config.plugins = [new UglifyJsPlugin({ minimize: true })];

// Dev target - example
} else {
    config.entry = "./example/app.js.coffee";
    config.output = {
        path: __dirname + '/example/',
        filename: 'bundle.js' }

    config.devtool = "cheap-module-source-map";
}

module.exports = config
