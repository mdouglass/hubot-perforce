# Description
#   Hubot script for interacting with Perforce
#
# Configuration:
#   HUBOT_P4CHARSET
#   HUBOT_P4CLIENT
#   HUBOT_P4HOST
#   HUBOT_P4LANGUAGE
#   HUBOT_P4PORT
#   HUBOT_P4USER
#
# Commands:
#
# URLs:
#   /hubot/perforce
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Matthew Douglass[@<org>]

P4 = require './perforce/p4'
{ inspect } = require 'util'

Options =
  charset:  process.env.HUBOT_P4CHARSET  or null
  client:   process.env.HUBOT_P4CLIENT   or null
  host:     process.env.HUBOT_P4HOST     or null
  language: process.env.HUBOT_P4LANGUAGE or null
  port:     process.env.HUBOT_P4PORT     or null
  user:     process.env.HUBOT_P4USER     or null

module.exports = (robot) ->
  robot.router.post '/hubot/perforce', (req, res) ->
    res.end()

    robot.logger.debug "Received perforce change notification: #{inspect req.body}"
    robot.p4.describe null, req.body.change, (error, output) ->
      robot.logger.debug "p4 describe\n\terror: #{inspect error}\n\tresults: #{inspect output}"
      if error?
        robot.emit 'perforce:error', output or error
      else
        robot.emit 'perforce:change', output

  # robot.on 'perforce:change', (change) ->
  #   robot.logger.warning "Perforce Change: #{inspect change}"

  p4 = new P4()
  p4.charset  = Options.charset
  p4.client   = Options.client
  p4.host     = Options.host
  p4.language = Options.language
  p4.port     = Options.port
  p4.user     = Options.user

  robot.emit 'perforce:ready', p4

  robot.p4 = p4
