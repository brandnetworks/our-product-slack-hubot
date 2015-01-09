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
#   <mention a JIRA issue> - Get basic information about the issue (must be watching the project first)
#   hubot watch jira project <PROJECT> - Start watching for issues with the prefix PROJECT
#   hubot stop watching <PROJECT> - stop watching a particular project
#   hubot status on <issue> - Get detailed status on a jira issue
#   hubot what projects are you watching? - get the list of jira projects that the bot is watching
#
# Author:
#   bmnick

# TODO: add support for multiple tickets in one message
# TODO: add support for truly removing listeners

Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

module.exports = (robot) ->
  robot.respond /watch jira project ?(.+)?/i, (msg) ->
    shortcode = msg.match[1]

    projects = robot.brain.get('jira-projects') or []
    projects.push shortcode
    robot.brain.set 'jira-projects', projects

    watch(robot, shortcode)

    msg.send "I'll let you know about issues from that project you mention"

  robot.respond /stop watching ?(.+)?/i, (msg) ->
    projects = robot.brain.get('jira-projects') or []
    projects.remove msg.match[1]
    robot.brain.set 'jira-projects', projects

    msg.send "Ignoring that project, it'll be reflected next time I reboot"

  robot.respond /what projects are you watching\??/i, (msg) ->
    projects = robot.brain.get('jira-projects') or []
    msg.send "I'm watching: " + projects.join(", ")

  robot.respond /status on ?(.+)?/i, (msg) ->
    load_issue robot, msg.match[1], (issue) ->
      text = issue_summary(issue)
      if text?
        msg.send text
      else
        msg.send "That ticket doesn't seem to exist..."

  robot.brain.on 'loaded', =>
    if !has_started_watching_projects
      has_started_watching_projects = true
      console.log("Brain is loaded for the first time, rewatching projects...")
      projects = robot.brain.get('jira-projects') or []
      for project in projects
        console.log("Watching project " + project + " after restart")
        watch(robot, project)

has_started_watching_projects = false

watch = (robot, project) ->
  robot.hear new RegExp(project + "-([0-9]*)", "i"), (mention) ->
    ticket = project + "-" + mention.match[1]

    load_issue robot, ticket, (issue) ->
      text = issue_summary issue
      mention.send text if text?

load_issue = (robot, issueNumber, completion) ->
  credentials = process.env.HUBOT_JIRA_READER_USERNAME + ":" + process.env.HUBOT_JIRA_READER_PASSWORD
  auth_header = 'Basic ' + new Buffer(credentials).toString('base64')

  robot.http(process.env.HUBOT_JIRA_INSTANCE_URL + "/rest/api/2/issue/" + issueNumber)
    .header('Authorization', auth_header)
    .get() (err, res, body) ->
      issue = JSON.parse(body)
      completion(issue)

issue_summary = (issue) ->
  if issue.fields
    process.env.HUBOT_JIRA_INSTANCE_URL + "/browse/" + issue.key + "|" + issue.key + ": " + issue.fields.summary + " (status: " + issue.fields.status.name + ")"
  else
    null
