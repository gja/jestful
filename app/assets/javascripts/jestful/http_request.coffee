class HttpRequest
  call: (request_hash, callback) ->
    request = new XMLHttpRequest()
    request.open(request_hash.method, request_hash.url)
    request.onreadystatechange = =>
      return unless request.readyState == 4
      callback.call(new Response(request))
    request.send(request_hash.data)

makeHttpRequest = (method, url, data, options) ->
  new HttpRequest().call(extend(options, {method: method, url: url}), new Callback(options))