// Legacy file with pre-existing violations
// This represents old code that hasn't been updated to modern standards

var globalCounter = 0; // ESLint: Prefer const or let

function incrementCounter() {
  globalCounter++; // Modifying global state
  console.log("Counter:", globalCounter); // ESLint: Unexpected console statement
  return globalCounter;
}

function checkValue(val) {
  if (val == null) { // ESLint: Use === instead of ==
    return false;
  }
  if (val == undefined) { // ESLint: Use === instead of ==
    return false;
  }
  return true;
}

function processData(data) {
  var result = []; // ESLint: Use const or let
  for (var i = 0; i < data.length; i++) { // ESLint: Use let instead of var
    if (data[i] != null) { // ESLint: Use !== instead of !=
      result.push(data[i]);
    }
  }
  return result;
}

// Unused variable
var unusedVar = "This is never used"; // ESLint: 'unusedVar' is assigned a value but never used

module.exports = {
  incrementCounter,
  checkValue,
  processData
};

