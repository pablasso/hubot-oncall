chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'reddit', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/oncall')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/oncall now/)

