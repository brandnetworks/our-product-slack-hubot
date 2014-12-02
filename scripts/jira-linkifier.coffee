# Description
#   Watches for JIRA issue mentions and provides information and a link
#
# Dependencies
#   None
#
# Configuration
#   HUBOT_JIRA_INSTANCE_URL
#
# Commands:
#   <mention a JIRA issue> - Get basic information about the issue
#   hubot watch jira project <PROJECT> - Start watching for issues with the prefix PROJECT
#   hubot status on <issue> - Get detailed status on a jira issue
#
# Author:
#   bmnick
module.exports = (robot) ->
  robot.respond /watch jira project ?(.+)?/i, (msg) ->
    projects = robot.brain.get('jira-projects') or []
    projects.push msg.match[1]
    robot.brain.set 'jira-projects', projects

    msg.send "Watching that project for you"

  robot.respond /what projects are you watching\??/i, (msg) ->
    projects = robot.brain.get('jira-projects') or []
    msg.send "I'm watching: " + projects
