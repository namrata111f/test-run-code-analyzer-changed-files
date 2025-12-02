// Utility functions with code quality issues

// Missing JSDoc
function formatDate(date) {
  var day = date.getDate(); // ESLint: Use const
  var month = date.getMonth() + 1; // ESLint: Use const
  var year = date.getFullYear(); // ESLint: Use const
  
  console.log("Formatting date:", date); // ESLint: Unexpected console
  
  return month + "/" + day + "/" + year; // String concatenation
}

// Function with too many parameters (code smell)
function createUser(name, email, age, address, phone, role, department, startDate) {
  return {
    name: name,
    email: email,
    age: age,
    address: address,
    phone: phone,
    role: role,
    department: department,
    startDate: startDate
  };
}

// No input validation
function divide(a, b) {
  return a / b; // Could divide by zero
}

// Unused function
function unusedHelper() {
  return "This function is never called";
}

// Missing error handling
function parseJSON(jsonString) {
  return JSON.parse(jsonString); // Could throw error
}

// Duplicate code
function isEmptyString(str) {
  if (str == null || str == undefined || str == "") { // ESLint: Use ===
    return true;
  }
  return false;
}

function isEmptyArray(arr) {
  if (arr == null || arr == undefined || arr.length == 0) { // ESLint: Use ===
    return true;
  }
  return false;
}

// Magic numbers
function calculateDiscount(price) {
  if (price > 100) {
    return price * 0.15; // What is 0.15? What is 100?
  } else if (price > 50) {
    return price * 0.10;
  }
  return price * 0.05;
}

// Var in loop
for (var i = 0; i < 10; i++) { // ESLint: Use let
  setTimeout(function() {
    console.log(i); // Will always log 10
  }, 100);
}

module.exports = {
  formatDate,
  createUser,
  divide,
  parseJSON,
  isEmptyString,
  isEmptyArray,
  calculateDiscount
};

