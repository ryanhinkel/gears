module.exports = {
    entry: "./src/js/app.js.coffee",
    output: {
        path: __dirname,
        filename: "bundle.js"
    },
    resolve: {
        extensions: ["", ".webpack.js", ".web.js", ".js", ".js.coffee"]
    },
    devtool: "#inline-source-map",
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" }
        ]
    }
};
