import XCTest

import TonClientSwiftTests

var tests = [XCTestCaseEntry]()
#if !canImport(ObjectiveC)
tests += TonClientSwiftTests.__allTests()
#endif
XCTMain(tests)
