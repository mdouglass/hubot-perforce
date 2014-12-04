# hubot-perforce
[![Build Status](https://travis-ci.org/mdouglass/hubot-perforce.svg?branch=master)](https://travis-ci.org/mdouglass/hubot-perforce)

Hubot script for receiving notifications from Perforce and interacting with Perforce.

**THIS PROJECT IS IN AN EARLY STATE, USE AT YOUR OWN RISK**

## Installation

In hubot project repo, run:

`npm install hubot-perforce --save`

Then add **hubot-perforce** to your `external-scripts.json`:

```json
["hubot-perforce"]
```

## Quick Start

1. Configure default p4

  An instance of `P4` is available at `robot.p4`. This instance needs to be configured for your Perforce server when Hubot starts. There are three different ways to accomplish this.

  If you do nothing else, the default p4 will be configured using the standard Perforce environment variables (see the [Perforce Manual](http://www.perforce.com/perforce/doc.current/manuals/cmdref/envars.html) for the details):
  ```
  P4CHARSET  P4CLIENT   P4HOST
  P4LANGUAGE P4PORT     P4USER
  ```

  If you wish to override the standard Perforce environment variables, you may specify any of the following custom environment variables:
  ```
  HUBOT_P4CHARSET  HUBOT_P4CLIENT   HUBOT_P4HOST
  HUBOT_P4LANGUAGE HUBOT_P4PORT     HUBOT_P4USER
  ```

  As a final alternative, you may configure the p4 instance at runtime:

  ```coffeescript
  module.exports = (robot) ->
    # Handle all notifications
    robot.on 'perforce:ready', (p4) ->
      p4.charset  = 'utf8'
      p4.client   = 'my-client'
      p4.host     = 'my-host'
      p4.port     = 'perforce:1666'
      p4.user     = 'me'
  ```

  **NOTE:** It is expected, that the configured Perforce user will already be logged in when Hubot is started. If this is not the case, use the `perforce:ready` event to execute a `P4.login` as needed by your configuration.

2. Configure Perforce trigger to notify Hubot

  Use the p4 triggers command to notify  **hubot-perforce** when a change is committed. In general, an HTTP POST to `/hubot/perforce` which the change number needs to be made. An example using `curl` is shown here:

  ```
  hubot-perforce change-commit //... "curl -d 'change=%change' http://hubot.example.com/hubot/perforce"
  ```

3. Listen for change events in your own code

  **hubot-perforce** will emit a `perforce:change` event whenever a change is committed. That event will contain the full details of the change (as returned by `p4 describe`)

  ```coffeescript
  { inspect } = require 'util'

  module.exports = (robot) ->
    robot.on 'perforce:change', (change) ->
      robot.logger.info "Perforce Change: #{inspect change}"
  ```

  ```
  [Wed Dec 03 2014 22:13:06 GMT-0800 (PST)] INFO Perforce Change: { code: 'stat',
  change: 12345,
  user: 'user',
  client: 'client',
  time: 1410399382,
  desc: 'Change',
  status: 'submitted',
  changeType: 'public',
  path: '//depot/path/...',
  files:
  [ { depotFile: '//depot/path/file.txt',
  action: 'edit',
  type: 'text',
  rev: 42,
  fileSize: 1024,
  digest: 'C24816CC89E4B289F338F2FE87DC04A0' } ] }
  ```

## P4 class

This section is intended to be an introduction to using `robot.p4`, but it has not been written yet.

- All commands can be sent via `p4.command` which matches general p4 command line of form `p4 [ options ] command [ arg ... ]`

  ```coffeescript
  opts = [ '-r', '3']
  command = 'opened'
  args = [ '-m', 100 ]
  robot.p4.command options, command, args, (error, output) ->
    robot.logger.info error
    robot.logger.info output
  ```
- Convenience commands
  - `p4.describe`, `p4.info`, `p4.istat`, `p4.streams`, etc.
- Response handling configuration
  - All default on, but can be turned off if needed/desired
  - `p4.responseInfersType`
  - `p4.responseSingleElementArrayToObject`
  - `p4.responseOrganized`
- `p4.maxBuffer` defaults to 200KB, may need to be upped for many use cases
