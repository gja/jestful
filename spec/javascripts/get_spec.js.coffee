describe 'GETs', ->
  Url = Jestful.Url

  it 'can make a successful GET call', ->
    new Url("http://localhost:3000/test/get").get (response) =>
      this.status = response.status
    waitsForDefinition =>
      this.status
    runs =>
      expect(this.status).toEqual(200)

  it 'can trap a not found', ->
    new Url("http://localhost:3000/test/not_found").get
      success: (response) =>
      not_found: (response) => this.status = response.status
    waitsForDefinition =>
      this.status
    runs =>
      expect(this.status).toEqual(404)

  it 'will transparently follow a redirect', ->
    new Url("http://localhost:3000/test/redirect").get
      success: (response) => this.status = response.status
    waitsForDefinition =>
      this.status
    runs =>
      expect(this.status).toEqual(200)