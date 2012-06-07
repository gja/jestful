STATUS_CODES =
  0 : 'cross_domain_security_violation'
  200 : 'ok'
  201 : 'created'
  204 : 'no_content'
  304 : 'not_modified'
  400 : 'bad_request'
  401 : 'unauthorized'
  403 : 'forbidden'
  404 : 'not_found'
  408 : 'request_timeout'
  409 : 'conflict'
  422 : 'unprocessable_entity'
  500 : 'internal_server_error'
  501 : 'not_implemented'
  502 : 'bad_gateway'
  503 : 'service_unavailable'
  504 : 'gateway_timeout'

class Callback
  constructor: (@options = {}) ->
  
  emptyCallback: (response) ->
    console.log("No callback registered for status code: " + response.status)

  statusClass: (status) ->
    return 'success' if 200 <= status < 300
    return 'failure' if 400 <= status

  bestCallback: (status) ->
    return @options if typeof(@options) == "function"
    return @options[status] if @options[status]
    return @options[STATUS_CODES[status]] if @options[STATUS_CODES[status]]
    status_class = this.statusClass(status)
    return @options[status_class] if @options[status_class]
    return @options.default if @options.default
    this.emptyCallback

  call: (response) ->
    bestCallback = this.bestCallback(response.status)
    bestCallback(response)

extendInPlace = (first, second) ->
  first[key] = value for key, value of second
  null

extend = (first, second) ->
  result = {}
  extendInPlace(result, first)
  extendInPlace(result, second)
  result

class HttpRequest
  call: (request_hash, callback) ->
    request = new XMLHttpRequest()
    request.open(request_hash.method, request_hash.url)
    request.onreadystatechange = =>
      return unless request.readyState == 4
      callback.call(new Response(request))
    request.send(request_hash.data)

class Url
  constructor: (@url) ->
  
  raw_ajax: (method, url, data, options) ->
    new HttpRequest().call(extend(options, {method: method, url: url}), new Callback(options))

  get: ([data]..., options) ->
    query_string = ""
    query_string = "#{query_string}&#{key}=#{value}" for key, value of data if data
    url = if query_string then "#{@url}?#{query_string}" else @url
    this.raw_ajax 'GET', url, null, options

class Response
  constructor: (@request) ->
    @status = @request.status
  body: -> @request.responseText
  jsonBody: -> JSON.parse(this.body())
  
api = this.Jestful = (this.Jestful || {})
internal = api.internal = (api.internal || {})

api.Url = Url
api.get = (url, [data]..., options) -> new Url(url).get(data, options)

internal.Callback = Callback
internal.extend = extend
internal.extendInPlace = extendInPlace