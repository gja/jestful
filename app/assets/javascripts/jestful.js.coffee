class Callback
  constructor: (@options = {}) ->
  
  STATUS_CODES:
    200 : 'ok'
  
  emptyCallback: (request) ->
    console.log("No callback registered for status code: " + request.status )

  bestCallback: (status) ->
    return @options[status] if @options[status]
    return @options[this.STATUS_CODES[status]] if @options[this.STATUS_CODES[status]]
    return @options.default if @options.default
    this.emptyCallback

  call: (request) ->
    bestCallback = this.bestCallback(request.status)
    bestCallback(request)

class Url
  constructor: (@url) ->
  
  get: (options) ->
    request = new XMLHttpRequest()
    request.open('GET', @url)
    request.onreadystatechange = =>
      this.readyStateChanged(request, options)
    request.send()
  
  readyStateChanged: (request, options) ->
    return unless request.readyState == 4
    new Callback(options).call(request)


api = this.Jestful = (this.Jestful || {})
internal = api.internal = (api.internal || {})

api.Url = Url

internal.Callback = Callback