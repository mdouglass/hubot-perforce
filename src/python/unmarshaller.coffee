{ inspect } = require 'util'

class ConsumingBuffer
  constructor: (buffer) ->
    @buffer = buffer
    @offset = 0

  hasMore: () ->
    @offset < @buffer.length

  readUInt8: () ->
    result = @buffer.readUInt8 @offset
    @offset += 1
    result

  readInt32LE: () ->
    result = @buffer.readInt32LE @offset
    @offset += 4
    result

  readString: (encoding, length) ->
    result = @buffer.toString encoding, @offset, @offset + length
    @offset += length
    result

  toString: () ->
    return "[ConsumingBuffer: at #{@offset}]"

class PythonNull


unmarshalNext = (buffer) ->
  type = String.fromCharCode buffer.readUInt8()

  switch type
    when '0'
      new PythonNull
    when 's'
      unmarshalString buffer
    when 'i'
      buffer.readInt32LE()
    when '{'
      unmarshalDict buffer
    else
      throw new Error("Unknown object type in #{buffer}: '#{type}'")

unmarshalDict = (buffer) ->
  dict = { }
  while true
    key = unmarshalNext buffer
    if key instanceof PythonNull
      break
    value = unmarshalNext buffer
    dict[key] = value
  dict

unmarshalString = (buffer) ->
  size = buffer.readInt32LE()
  string = buffer.readString 'utf8', size
  string

exports.unmarshal = (contents) ->
  return null if contents.length == 0
  try
    buffer = new ConsumingBuffer(new Buffer(contents, 'binary'))
    unmarshalNext buffer
  catch error
    error

exports.unmarshalAll = (contents) ->
  return null if contents.length == 0
  try
    buffer = new ConsumingBuffer(new Buffer(contents, 'binary'))
    while buffer.hasMore()
      unmarshalNext buffer
  catch error
    error

module.exports = exports
