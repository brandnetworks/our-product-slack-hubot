# Notifies about Crashlytics crashes via a Crashlytics web hook
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   Just put this url <HUBOT_URL>:<PORT>/hubot/jenkins-notify?room=<room> to your Jenkins
#   Notification config. See here: https://wiki.jenkins-ci.org/display/JENKINS/Notification+Plugin
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/crashlytics-notify?room=<room>
#
# Authors:
#   bmnick

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.post "/hubot/crashlytics-notify", (req, res) ->

    @failing ||= []
    query = querystring.parse(url.parse(req.url).query)

    try
      data = req.body

      if data.event == 'verification'
        console.log "verified with Crashlytics"

      if data.event == 'issue_impact_change'
        robot.messageRoom '#publishmobileautomati', 'Stuffs broke!'
        res.writeHead 204, { 'Content-Length': 0}

      res.end()
    catch error
      console.log "jenkins-notify error: #{error}. Data: #{req.body}"
      console.log error.stack
