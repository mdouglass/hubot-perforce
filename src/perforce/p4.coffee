{ execFile } = require 'child_process'
{ inspect } = require 'util'
{ unmarshal, unmarshalAll } = require '../python/unmarshaller'

class P4
  constructor: () ->
    # p4 command line options
    @charset = null
    @client = null
    @host = null
    @language = null
    @port = null
    @user = null
    @executable = null

    # p4 exec options
    @maxBuffer = 200*1024

    # response conversion behaviors
    @responseInfersType = true
    @responseSingleElementArrayToObject = true
    @responseOrganized = true

    # logging
    @logger = null
    
  exec: (args, callback) ->
    options = 
      # 'cwd': '',
      'env': process.env,
      'encoding': 'binary',
      'timeout': 0,
      'maxBuffer': @maxBuffer,
      'killSignal': 'SIGTERM'

    allArgs = []
    allArgs.push "-C", @charset if @charset
    allArgs.push "-c", @client if @client
    allArgs.push "-H", @host if @host
    allArgs.push "-L", @language if @language
    allArgs.push "-p", @port if @port
    allArgs.push "-u", @user if @user
    allArgs.push "-G"
    allArgs.push args...
    # console.log allArgs

    # MSED - Maybe convert to spawn for more flexibility
    @logger?.debug "exec: p4 #{allArgs.join(' ')}"
    execFile @executable or 'p4', allArgs, options, (error, stdout, stderr) =>
      if stderr and not error
        callback new Error('Unknown error on stderr'), @processResponse unmarshal stderr
      else
        callback error, @processResponse unmarshalAll stdout 

  processResponse: (response) ->
    return response if not response

    if @responseInfersType
      response = @inferTypes response

    if @responseSingleElementArrayToObject
      if response.length == 1
        response = response[0]

    if @responseOrganized
      loop
        i = i + 1 or 0
        break if ('depotFile'+i) not of response
        file =
          depotFile: response['depotFile' + i]
          action:    response['action'    + i]
          type:      response['type'      + i]
          rev:       response['rev'       + i]
          fileSize:  response['fileSize'  + i]
          digest:    response['digest'    + i]
        delete response['depotFile' + i]
        delete response['action'    + i]
        delete response['type'      + i]
        delete response['rev'       + i]
        delete response['fileSize'  + i]
        delete response['digest'    + i]
        response.files = response.files or []
        response.files.push file

    response

  inferTypes: (object) ->
    switch typeof object
      when 'Array'
        for value in object
          @inferTypes value
      when 'string'
        switch 
          when object == 'false' then false
          when object == 'true' then true
          when isFinite(object) then parseInt(object, 10) 
          else object
      else
        for own key, value of object
          object[key] = @inferTypes value
        object

  command: (options, command, commandArgs, callback) ->
    args = []
    args.push options... if options?
    args.push command
    args.push commandArgs... if commandArgs?
    @exec args, callback

  info: (callback) ->
    @command null, 'info', null, callback

  streams: (args, callback) ->
    @command null, 'streams', args, callback

  istat: (args, stream, callback) ->
    commandArgs = (args ? []).concat [ stream ]
    @command null, 'istat', commandArgs, callback

  describe: (args, change, callback) ->
    commandArgs = (args ? []).concat [ change ]
    @command null, 'describe', commandArgs, callback

module.exports = P4
