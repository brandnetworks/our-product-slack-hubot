# Description
#   Watches for JIRA issue mentions and provides information and a link
#
# Dependencies
#   None
#
# Configuration
#   HUBOT_JIRA_INSTANCE_URL
#   HUBOT_JIRA_READER_USERNAME
#   HUBOT_JIRA_READER_PASSWORD
#
# Commands:
#   <mention a JIRA issue> - Get basic information about the issue
#   hubot watch jira project <PROJECT> - Start watching for issues with the prefix PROJECT
#   hubot stop watching <PROJECT> - stop watching a particular project
#   hubot status on <issue> - Get detailed status on a jira issue
#   hubot what projects are you watching? - get the list of jira projects that the bot is watching
#
# Author:
#   bmnick

Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

module.exports = (robot) ->
  robot.respond /watch jira project ?(.+)?/i, (msg) ->
    shortcode = msg.match[1]

    projects = robot.brain.get('jira-projects') or []
    projects.push shortcode
    robot.brain.set 'jira-projects', projects

    robot.hear new Regexp(shortcode + "-([0-9]*)", "i"), (mention) ->
      robot.http(process.env.HUBOT_JIRA_INSTANCE_URL + "/rest/api/2/issue/" + shortcode + "-" + mention.match[1])
        .get( (err, req) ->
          req.auth(process.env.HUBOT_JIRA_READER_USERNAME, process.env.HUBOT_JIRA_READER_PASSWORD)
        ) (err, res, body) ->
          issue = JSON.parse(body)
          mention.send(issue.key + ": " + issue.fields.summary + "(" + issue.fields.customfield_10300 + ")")

      # mention.send("Issue at: https://jira.brandnetworksinc.com/browse/" + shortcode + "-" + mention.match[1])

    msg.send "Watching that project for you"

  robot.respond /stop watching ?(.+)?/i, (msg) ->
    projects = robot.brain.get('jira-projects') or []
    projects.remove msg.match[1]
    robot.brain.set 'jira-projects', projects

    msg.send "Ignoring that project again"

  robot.respond /what projects are you watching\??/i, (msg) ->
    projects = robot.brain.get('jira-projects') or []
    msg.send "I'm watching: " + projects

  robot.respond /status on ?(.+)?/i, (msg) ->
    # unimplemented
    msg.send "someday... email George about API credentials if you're impatient"
