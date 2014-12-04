chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
{ inspect } = require 'util'
P4 = require('../src/perforce/p4')

expect = chai.expect

describe 'hubot-perforce', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/hubot-perforce')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/hello/)

  # it 'p4 info', (done) ->
  #   p4 = new P4
  #   p4.info (error, result) ->
  #     console.log "error:  #{inspect error}"
  #     console.log "result: #{inspect result}"
  #     done()

  # it 'p4 unknown', (done) ->
  #   p4 = new P4
  #   p4.exec [ 'this_does_not_exist' ], (error, result) ->
  #     console.log "error:  #{inspect error}"
  #     console.log "result: #{inspect result}"
  #     done()

  # it 'p4 streams', (done) ->
  #   p4 = new P4
  #   p4.exec [ 'streams' ], (error, result) ->
  #     console.log "error:  #{inspect error}"
  #     console.log "result: #{inspect result}"
  #     done()

  # it 'p4 describe', (done) ->
  #   p4 = new P4
  #   p4.port = "ssl:perforce01.sjc.kixeye.com:2667"
  #   p4.charset = "utf8"
  #   p4.exec [ 'describe', '30000' ], (error, result) ->
  #     console.log "error:  #{inspect error}"
  #     console.log "result: #{inspect result}"
  #     done()

  # it 'p4 integration test', (done) ->
  #   p4 = new P4
  #   p4.port = "ssl:perforce01.sjc.kixeye.com:2667"
  #   p4.charset = "utf8"

  #   p4.streams [ "-F", "Type=development | Type=task", "//wcra/..." ], (error, streams) ->
  #     expect(error).is.null()
  #     expect(streams).is.not.null()
  #     for stream in streams
  #       do (stream) ->
  #         p4.istat [ "-a", "-f" ], stream.Stream, (error, status) ->
  #           expect(error).is.null()
  #           expect(status).is.not.null()

  #           # console.log "#{stream.Name} #{stream.Stream} #{stream.Parent}"
  #           if status.integFromParent
              
  #             console.log "Tell #{stream.Owner} WARNING: Pending integration from parent"
