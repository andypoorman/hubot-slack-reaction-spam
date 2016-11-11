# Description:
#   React Spam
#
# Dependencies:
#   hubot-slack
#   hubot-slack-reaction
#   node-emoji
#
# Configuration:
#   None
#
# Author:
#   andypoorman

slack = require 'hubot-slack'
default_emoji = require('node-emoji').emoji

module.exports = (robot) ->
  emoji = {}
  options =
    endpoint: "https://slack.com/api/emoji.list"

  robot.hear /./i, (msg) ->
    if Object.keys(emoji).length is 0
      robot.http(options.endpoint + "?token=" + process.env.HUBOT_SLACK_TOKEN)
      .get() (err, res, body) ->
        json_body = JSON.parse(body)
        emoji = default_emoji
        for k, v of json_body.emoji
          emoji[k] = v

    for k, v of emoji
      emoji_name = k.replace('+','\\+')
      re = new RegExp('\\b'+ emoji_name + '\\b' , 'g');
      if msg.message.text.match re
        robot.emit 'slack.reaction',
        message: msg.message
        name: emoji_name
