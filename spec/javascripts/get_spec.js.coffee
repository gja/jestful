describe 'GETs', ->
  Url = Jestful.Url

  it 'can make a successful GET call', ->
    new Url("http://localhost:3000/test/get").get (response) =>
      this.status = response.status
    assert_eventually_equal 200, => this.status

  it 'returns the text back', ->
    new Url("http://localhost:3000/test/get").get (response) =>
      this.response = response.body()
    assert_eventually_equal 'success', => this.response

  describe 'for other status codes', ->
    it 'can trap a not found', ->
      new Url("http://localhost:3000/test/not_found").get
        success: (response) =>
        not_found: (response) => this.status = response.status
      assert_eventually_equal 404, => this.status

    it 'will transparently follow a redirect', ->
      new Url("http://localhost:3000/test/redirect").get
        success: (response) => this.status = response.status
      assert_eventually_equal 200, => this.status

  it 'can fetch a json object', ->
    new Url("http://localhost:3000/test/json").get (response) =>
      this.response = response.jsonBody()
    assert_eventually_equal {foo: "bar"}, => this.response

  describe 'passing parameters to the server', ->
    it 'can pass a get parameter to the server', ->
      new Url("http://localhost:3000/test/return_foo").get {foo: 'bar'}, (response) =>
        this.response = response.body()
      assert_eventually_equal "bar", => this.response

    it 'can pass a parameter with a space in it', ->
      new Url("http://localhost:3000/test/return_foo").get {foo: 'foo bar'}, (response) =>
        this.response = response.body()
      assert_eventually_equal "foo bar", => this.response

  describe "static API", ->
    it 'can make a successful GET call', ->
      Jestful.get "http://localhost:3000/test/get", (response) =>
        this.status = response.status
      assert_eventually_equal 200, => this.status

    it 'can pass a get parameter to the server', ->
      Jestful.get "http://localhost:3000/test/return_foo", {foo: 'bar'}, (response) =>
        this.response = response.body()
      assert_eventually_equal "bar", => this.response