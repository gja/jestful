class Url
  constructor: (@url) ->

  get: ([data]..., options) ->
    query_string = ""
    query_string = "#{query_string}&#{key}=#{value}" for key, value of data if data
    url = if query_string then "#{@url}?#{query_string}" else @url
    makeHttpRequest 'GET', url, null, options

api.Url = Url