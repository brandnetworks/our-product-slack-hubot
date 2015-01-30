# BN Product Slack Hubot

This is a chat bot built on Github's Hubot framework. It's currently deployed to Heroku under @bmnick 's account, just because it was the easisest way to initially stand it up.

Right now it's called "Alfred", though that name may change many many times.

## Custom Scripts

We have some custom scripts that provide useful functionality.

### Jira Linkifier

This is a script that handles automatically linking and providing information on Jira issues that are mentioned in chats. In order to opt into this, simply say "&lt;hubot&gt; watch jira project &lt;short code&gt;", and it will begin chiming in whenever an issue from that project is mentioned. If you later want to opt out, "&lt;hubot&gt; stop watching &lt;short code&gt;" will let you do so.

This also provides a way to look up a specific ticket quickly, with "&lt;hubot&gt; status on &lt;full issue number&gt;". This does not require pre-registration of the project.

### Weather

We can ask hubot about the weather, with "&lt;hubot&gt; weather [location]". If no location is provided, it defaults to our Rochester office.

### Crashlytics Notifications

For right now, this is a way of allowing additional services to speak for slack without more integrations, which helps with the integration limits in Slack and allows moving between accounts more easily. This takes crashes found in crashlytics and informs the mobile teams about those crashes. Eventually, this should be expanded to allow modifying beta deployments through hubot as well, but that's waiting on some API updates from Crashlytics.

## Contributing

This is up on our github page so we can all contribute to making our chats just a little more weird, awesome and automatic. If you have an idea, it's pretty easy to start adding scripts to do fun or useful things! There are a few scripts in here you can steal from, including the "example.coffee" script that contains a lot of high level demonstrations.

### Submission guidelines

Due to how this deploys, and to prevent downtime for our hopefully increasingly useful bot, I would prefer that all new features be developed in a fork in a feature branch. Submitting a pull request will then allow someone to review the request (and eventually have CI run against it) and integrate when possible.

The master branch needs to be kept clean, as any new commits on this branch will result in a new deploy to heroku.

### Useful documentation

* [hubot's home](http://hubot.github.com)
* [hubot-scripts](https://github.com/github/hubot-scripts/)
* [Scripting Guide](https://github.com/github/hubot/blob/master/docs/scripting.md)
* [Redis brain](https://github.com/hubot-scripts/hubot-redis-brain)
* [Coffeescript](http://coffeescript.org)
