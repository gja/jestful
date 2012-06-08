class Response
  constructor: (@request) ->
    @status = @request.status
  body: -> @request.responseText
  jsonBody: -> JSON.parse(this.body())