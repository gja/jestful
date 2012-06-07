describe 'extend', ->
  extend = Jestful.internal.extend
  extendInPlace = Jestful.internal.extendInPlace

  it 'can extend an array in place', ->
    first = {a: "b"}
    second = {b : "c"}
    extendInPlace(first, second)
    expect(first.b).toEqual("c")

  it 'can extend an object into a new object', ->
    first = {a: "b"}
    second = {b : "c"}
    expect(extend(first,second)).toEqual({a : "b", b: "c"})
    expect(first.b).toBeUndefined()