describe 'Callback', ->
  Callback = Jestful.internal.Callback

  it 'can trigger a callback by status code', ->
    callback = new Callback {
      200: (x) -> x.body
    }
    expect(callback.call(status: 200, body: "foo")).toBe("foo")

  it 'can trigger a callback by status code name', ->
    callback = new Callback {
      ok: (x) -> x.body
    }
    expect(callback.call(status: 200, body: "bar")).toBe("bar")

  it 'will trigger the default callback otherwise', ->
    callback = new Callback {
      default: (x) -> x.body
    }
    expect(callback.call(status: 200, body: "baz")).toBe("baz")

  it 'will trigger the success handler', ->
    callback = new Callback {
      success: (x) -> x.body
    }
    expect(callback.call(status: 200, body: "baz")).toBe("baz")

  it 'does not trigger the success handler for errors', ->
    callback = new Callback {
      success: (x) -> 'success'
      default: (x) -> 'default'
    }
    expect(callback.call(status: 404)).toBe("default")

  it 'can be created with a default method', ->
    callback = new Callback (x) -> x.status
    expect(callback.call(status: 404)).toBe(404)