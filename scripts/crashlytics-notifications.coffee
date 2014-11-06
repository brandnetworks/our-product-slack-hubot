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

  robot.router.post "/hubot/crashltics-notify", (req, res) ->

    @failing ||= []
    query = querystring.parse(url.parse(req.url).query)

    res.end('')

    envelope.room = query.room if query.room

    try
      data = req.body

      if data.event == 'verification'
        console.log "verified with Crashlytics"
        res.writeHead 204, { 'Content-Length': 0}
        res.end()

      if data.event == 'issue_impact_change'
        robot.messageRoom '#publishmobileautomati', 'Stuffs broke!'

    catch error
      console.log "jenkins-notify error: #{error}. Data: #{req.body}"
      console.log error.stack
