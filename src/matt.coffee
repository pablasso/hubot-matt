# Description:
#   Create a celebration matt meme
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_MEMEGEN_USERNAME
#   HUBOT_MEMEGEN_PASSWORD
#
# Commands:
#   hubot matt me <text> - Generates the celebration matt meme with the bottom caption of <text>
#
# Author:
#   Juan Pablo Ortiz <pablasso@gmail.com>

inspect = require('util').inspect

module.exports = (robot) ->
  robot.respond /matt me (.+)/i, (msg) ->
    generatorID = 3856768
    imageID = 12154489
    memeGenerator msg, generatorID, imageID, msg.match[1], (url) ->
      msg.send url

memeGenerator = (msg, generatorID, imageID, text, callback) ->
  username = process.env.HUBOT_MEMEGEN_USERNAME
  password = process.env.HUBOT_MEMEGEN_PASSWORD

  unless username? and password?
    msg.send "MemeGenerator account isn't setup. Sign up at http://memegenerator.net"
    msg.send "Then ensure the HUBOT_MEMEGEN_USERNAME and HUBOT_MEMEGEN_PASSWORD environment variables are set"
    return

  msg.http('http://version1.api.memegenerator.net/Instance_Create')
    .query
      username: username,
      password: password,
      languageCode: 'en',
      generatorID: generatorID,
      imageID: imageID,
      text0: '',
      text1: text
    .get() (err, res, body) ->
      if err
        msg.reply "Ugh, I got an exception trying to contact memegenerator.net:", inspect(err)
        return

      jsonBody = JSON.parse(body)
      success = jsonBody.success
      errorMessage = jsonBody.errorMessage
      result = jsonBody.result

      if not success
        msg.reply "Ugh, stupid request to memegenerator.net failed: \"#{errorMessage}.\" What does that even mean?"
        return

      instanceID = result?.instanceID
      instanceURL = result?.instanceUrl
      img = result?.instanceImageUrl

      unless instanceID and instanceURL and img
        msg.reply "Ugh, I got back weird results from memegenerator.net. Expected an image URL, but couldn't find it in the result. Here's what I got:", inspect(jsonBody)
        return

      msg.http(instanceURL).get() (err, res, body) ->
        # Need to hit instanceURL so that image gets generated
        if preferredDimensions?
          callback "http://images.memegenerator.net/instances/#{preferredDimensions}/#{instanceID}.jpg"
        else
          callback "http://images.memegenerator.net/instances/#{instanceID}.jpg"
