extendInPlace = (first, second) ->
  first[key] = value for key, value of second
  null

extend = (first, second) ->
  result = {}
  extendInPlace(result, first)
  extendInPlace(result, second)
  result

internal.extend = extend
internal.extendInPlace = extendInPlace