function waitsForDefinition (func) {
  waitsFor(function() {
    var value = func();
    return value !== null && typeof(value) != 'undefined';
  }, "timed out while waiting for definition", 1000);
}