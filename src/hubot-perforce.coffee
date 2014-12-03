# Description
#   Hubot script for interacting with Perforce
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Matthew Douglass[@<org>]

P4 = require './perforce/p4'
{ inspect } = require 'util'

module.exports = (robot) ->
  robot.respond /hello/, (msg) ->
    msg.reply "hello!"
