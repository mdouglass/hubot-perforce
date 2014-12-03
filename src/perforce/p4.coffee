# function execP4(p4cmd, options, callback) {
#   if (typeof options === 'function') {
#     callback = options;
#     options = undefined;
#   }

#   var ob = optionBuilder(options);
#   var cmd = ['p4', p4cmd, ob.args.join(' '), ob.files.join(' ')];
#   var child = exec(cmd.join(' '), function (err, stdout, stderr) {
#     if (err) return callback(err);
#     if (stderr) return callback(new Error(stderr));
#     return callback(null, stdout);
#   });
#   if (ob.stdin.length > 0) {
#     ob.stdin.forEach(function (line) {
#       child.stdin.write(line + '\n');
#     });
#     child.stdin.emit('end');
#   }
# }

{ execFile } = require 'child_process'
{ inspect } = require 'util'

class PythonNull

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

class P4
  constructor: () ->
    return

  execute: (args, callback) ->
    options = 
      # 'cwd': '',
      # 'env': '',
      'encoding': 'binary',
      'timeout': 0,
      'maxBuffer': 200*1024,  # MSED - Correct this, 200KB limit is too low
      'killSignal': 'SIGTERM'

    # MSED - Maybe convert to spawn for more flexibility
    execFile 'p4', args, options, (error, stdout, stderr) =>
      callback error, @unmarshal stdout, @unmarshal stderr

  unmarshal: (contents) ->
    try
      buffer = new ConsumingBuffer(new Buffer(contents, 'binary'))
      while buffer.hasMore()
        @unmarshalObject buffer
    catch error
      error

  unmarshalObject: (buffer) ->
    type = String.fromCharCode buffer.readUInt8()

    switch type
      when '0'
        new PythonNull
      when 's'
        @unmarshalString buffer
      when 'i'
        buffer.readInt32LE()
      when '{'
        @unmarshalDict buffer
      else
        throw new Error("Unknown object type in #{buffer}: '#{type}'")

  unmarshalDict: (buffer) ->
    dict = { }
    while true
      key = @unmarshalObject buffer
      if key instanceof PythonNull
        break
      value = @unmarshalObject buffer
      dict[key] = value
    dict

  unmarshalString: (buffer) ->
    size = buffer.readInt32LE()
    string = buffer.readString 'utf8', size
    string

module.exports = P4
