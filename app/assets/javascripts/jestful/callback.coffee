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

emptyCallback: (response) ->
  console.log("No callback registered for status code: " + response.status)

statusClass: (status) ->
  return 'success' if 200 <= status < 300
  return 'failure' if 400 <= status

class Callback
  constructor: (@options = {}) ->

  bestCallback: (status) ->
    return @options if typeof(@options) == "function"
    return @options[status] if @options[status]
    return @options[STATUS_CODES[status]] if @options[STATUS_CODES[status]]
    status_class = statusClass(status)
    return @options[status_class] if @options[status_class]
    return @options.default if @options.default
    emptyCallback

  call: (response) ->
    bestCallback = this.bestCallback(response.status)
    bestCallback(response)

internal.Callback = Callback