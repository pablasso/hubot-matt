chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'matt', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/matt')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/matt me/)

