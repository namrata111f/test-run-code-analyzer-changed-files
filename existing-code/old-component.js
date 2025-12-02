// Old component with various code quality issues

var DEBUG = true; // ESLint: Use const

function OldComponent() {
  var state = { // ESLint: Use const or let
    count: 0,
    items: []
  };

  this.render = function() {
    if (DEBUG == true) { // ESLint: Use ===, and DEBUG is already boolean
      console.log("Rendering component..."); // ESLint: Unexpected console
    }

    var html = ""; // ESLint: Use let
    for (var i = 0; i < state.items.length; i++) { // ESLint: Use let
      html += "<li>" + state.items[i] + "</li>"; // String concatenation
    }
    return html;
  };

  this.setState = function(newState) {
    // No validation - could cause issues
    state = Object.assign(state, newState);
    this.render();
  };

  this.addItem = function(item) {
    if (item != undefined && item != null) { // ESLint: Use !== and !==
      state.items.push(item);
      console.log("Added item:", item); // ESLint: Unexpected console
    }
  };
}

// Global function without proper error handling
function fetchData(url) {
  var xhr = new XMLHttpRequest(); // ESLint: Prefer fetch API
  xhr.open('GET', url);
  xhr.send();
  // No error handling
  return xhr.responseText; // This will be undefined when called
}

// Deeply nested conditionals
function complexLogic(a, b, c) {
  if (a == true) { // ESLint: Use ===
    if (b == true) { // ESLint: Use ===
      if (c == true) { // ESLint: Use ===
        console.log("All true"); // ESLint: Unexpected console
        return 1;
      } else {
        return 0;
      }
    }
  }
  return -1;
}

module.exports = OldComponent;

