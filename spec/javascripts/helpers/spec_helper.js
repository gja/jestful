function waitsForDefinition(func) {
  waitsFor(function() {
    var value = func();
    return value !== null && typeof(value) != 'undefined';
  }, "timed out while waiting for definition", 1000);
}

function assert_eventually_equal(value, func) {
  waitsForDefinition(func);
  runs(function() {
    expect(func()).toEqual(value);
  });
}