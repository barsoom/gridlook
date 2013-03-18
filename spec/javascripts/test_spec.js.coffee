#= require ./spec_helper

describe "jQuery.present", ->
  beforeEach ->
    render "test", record_id: "hello"

  it "it can run js unit tests", ->
    $("#hello").length.should.equal(1)
