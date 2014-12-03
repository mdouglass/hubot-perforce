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

  it 'p4 info', (done) ->
    p4 = new P4
    p4.execute [ '-G', 'info' ], (error, stdout, stderr) ->
      console.log "error:  #{inspect error}"
      console.log typeof stdout
      console.log "stdout: #{inspect stdout}"
      console.log typeof stderr
      console.log "stderr: #{inspect stderr}"
      done()

  # it 'p4 error', (done) ->
  #   p4 = new P4
  #   p4.execute [ '-G', 'error' ], (error, stdout, stderr) ->
  #     console.log "error:  #{inspect error}"
  #     console.log typeof stdout
  #     console.log "stdout: #{inspect stdout}"
  #     console.log typeof stderr
  #     console.log "stderr: #{inspect stderr}"
  #     done()

  it 'p4 streams', (done) ->
    p4 = new P4
    p4.execute [ '-G', 'streams' ], (error, stdout, stderr) ->
      console.log "error:  #{inspect error}"
      console.log typeof stdout
      console.log "stdout: #{inspect stdout}"
      console.log typeof stderr
      console.log "stderr: #{inspect stderr}"
      done()

  it 'p4 describe', (done) ->
    p4 = new P4
    p4.execute [ '-G', 'describe', '30000' ], (error, stdout, stderr) ->
      console.log "error:  #{inspect error}"
      console.log typeof stdout
      console.log "stdout: #{inspect stdout}"
      console.log typeof stderr
      console.log "stderr: #{inspect stderr}"
      done()
