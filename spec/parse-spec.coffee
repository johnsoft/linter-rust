LinterRust = require '../lib/linter-rust'

linter = new LinterRust()

describe "LinterRust::parse", ->
  it "should return 0 messages for an empty string", ->
    expect(linter.parse('')).toEqual([])

  it "should properly parse one line error message", ->
    expect(linter.parse('my/awesome file.rs:1:2: 3:4 error: my awesome text\n'))
      .toEqual([{
        type: 'Error'
        text: 'my awesome text'
        filePath: 'my/awesome file.rs'
        range: [[0, 1], [2, 3]]
      }])

  it "should properly parse one line warning message", ->
    expect(linter.parse('foo:33:44: 22:33 warning: äüö<>\n'))
      .toEqual([{
        type: 'Warning',
        text: 'äüö<>'
        filePath: 'foo'
        range: [[32, 43], [21, 32]]
      }])

  it "should return messages with a range of at least one character", ->
    expect(linter.parse('foo:1:1: 1:1 error: text\n'))
      .toEqual([{
        type: 'Error'
        text: 'text'
        filePath: 'foo'
        range: [[0, 0], [0, 1]]
      }])
    expect(linter.parse('foo:1:1: 2:1 error: text\n'))
      .toEqual([{
        type: 'Error'
        text: 'text'
        filePath: 'foo'
        range: [[0, 0], [1, 1]]
      }])