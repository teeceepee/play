const environment = require('./environment')

const config = environment.toWebpackConfig()
config.devtool = false

module.exports = config
