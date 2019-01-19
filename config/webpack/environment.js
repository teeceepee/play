const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue =  require('./loaders/vue')
const typescript = require('./loaders/typescript')

environment.loaders.append('typescript', typescript)
environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('vue', vue)

environment.config.externals = {
  'ml5': 'ml5',
}

module.exports = environment
