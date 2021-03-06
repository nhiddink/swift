// RUN: %target-swift-frontend -typecheck -verify fix-string-substring-conversion %s

let s = "Hello"
let ss = s[s.startIndex..<s.endIndex]

// CTP_Initialization
do {
  let s1: Substring = { return s }()
  _ = s1
}

// CTP_ReturnStmt
do {
  func returnsASubstring() -> Substring {
    return s
  }
}

// CTP_ThrowStmt
// Doesn't really make sense for this fix-it - see case in diagnoseContextualConversionError:
// The conversion destination of throw is always ErrorType (at the moment)
// if this ever expands, this should be a specific form like () is for
// return.

// CTP_EnumCaseRawValue
// Substrings can't be raw values because they aren't literals.

// CTP_DefaultParameter
do {
  func foo(x: Substring = s) {}
}

// CTP_CalleeResult
do {
  func getString() -> String { return s }
  let gottenSubstring: Substring = getString()
  _ = gottenSubstring
}

// CTP_CallArgument
do {
  func takesASubstring(_ ss: Substring) {}
  takesASubstring(s)
}

// CTP_ClosureResult
do {
  [s].map { (x: String) -> Substring in x }
}

// CTP_ArrayElement
do {
  let a: [Substring] = [ s ]
  _ = a
}

// CTP_DictionaryKey
do {
  let d: [ Substring : Substring ] = [ s : ss ]
  _ = d
}

// CTP_DictionaryValue
do {
  let d: [ Substring : Substring ] = [ ss : s ]
  _ = d
}

// CTP_CoerceOperand
do {
  let s1: Substring = s as Substring
  _ = s1
}

// CTP_AssignSource
do {
  let s1: Substring = s
  _ = s1
}

