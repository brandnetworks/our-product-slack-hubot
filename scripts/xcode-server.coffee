# Description
#   Notifies based on the results of xcode builds and controls xcode builds
#
# Dependencies
#   None
#
# Configuration
#   None
#
# Commands:
#   hubot build <bot name> - Start a build for bot named <bot name> UNIMPLEMENTED
#
# Author:
#   bmnick

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/xcode-publish-notify", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    app = query.app || null
    success = query.success == "true" || false
    version = query.version || null
    number = query.number || null
    error = query.error || null

    if success
      robot.messageRoom '#publishmobileautomati', 'Built ' + app + ' ' + version + '-' + number + ' successfully. Currently available on Crashlytics for download.'
    else
      robot.messageRoom '#publishmobileautomati', 'FAILED while building ' + app + ' with error ' + error

    res.writeHead 204, { 'Content-Length': 0}

    res.end()
