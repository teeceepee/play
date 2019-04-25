const { environment } = require('@rails/webpacker')
const typescript = require('./loaders/typescript')

environment.loaders.append('typescript', typescript)

environment.config.externals = {
  'ml5': 'ml5',
}

module.exports = environment
