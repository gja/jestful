STATUS_CODES =
  0 : 'cross_domain_security_violation'
  100 : 'continue'
  101 : 'switching_protocols'
  102 : 'processing'
  200 : 'ok'
  201 : 'created'
  202 : 'accepted'
  203 : 'non_authoritative_information'
  204 : 'no_content'
  205 : 'reset_content'
  206 : 'partial_content'
  207 : 'multi_status'
  226 : 'im_used'
  300 : 'multiple_choices'
  # 301 : 'moved_permanently'
  # 302 : 'found'
  # 303 : 'see_other'
  304 : 'not_modified'
  305 : 'use_proxy'
  306 : 'reserved'
  # 307 : 'temporary_redirect'
  400 : 'bad_request'
  401 : 'unauthorized'
  402 : 'payment_required'
  403 : 'forbidden'
  404 : 'not_found'
  405 : 'method_not_allowed'
  406 : 'not_acceptable'
  407 : 'proxy_authentication_required'
  408 : 'request_timeout'
  409 : 'conflict'
  410 : 'gone'
  411 : 'length_required'
  412 : 'precondition_failed'
  413 : 'request_entity_too_large'
  414 : 'request_uri_too_long'
  415 : 'unsupported_media_type'
  416 : 'requested_range_not_satisfiable'
  417 : 'expectation_failed'
  418 : 'im_a_teapot'
  422 : 'unprocessable_entity'
  423 : 'locked'
  424 : 'failed_dependency'
  426 : 'upgrade_required'
  500 : 'internal_server_error'
  501 : 'not_implemented'
  502 : 'bad_gateway'
  503 : 'service_unavailable'
  504 : 'gateway_timeout'
  505 : 'http_version_not_supported'
  506 : 'variant_also_negotiates'
  507 : 'insufficient_storage'
  510 : 'not_extended'

class Callback
  constructor: (@options = {}) ->
  
  emptyCallback: (request) ->
    console.log("No callback registered for status code: " + request.status)

  statusClass: (status) ->
    return 'success' if 200 <= status < 300
    # return 'redirect' if 300 <= status < 400
    return 'failure' if 400 <= status

  bestCallback: (status) ->
    return @options if typeof(@options) == "function"
    return @options[status] if @options[status]
    return @options[STATUS_CODES[status]] if @options[STATUS_CODES[status]]
    status_class = this.statusClass(status)
    return @options[status_class] if @options[status_class]
    return @options.default if @options.default
    this.emptyCallback

  call: (request) ->
    bestCallback = this.bestCallback(request.status)
    bestCallback(request)

class Url
  constructor: (@url) ->
  
  raw_ajax: (method, data, options) ->
    request = new XMLHttpRequest()
    request.open(method, @url)
    request.onreadystatechange = =>
      this.readyStateChanged(request, options)
    request.send(data)

  get: (options) ->
    this.raw_ajax 'GET', null, options
  
  readyStateChanged: (request, options) ->
    return unless request.readyState == 4
    new Callback(options).call(request)

api = this.Jestful = (this.Jestful || {})
internal = api.internal = (api.internal || {})

api.Url = Url

internal.Callback = Callback