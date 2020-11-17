#if !canImport(ObjectiveC)
import XCTest

extension BindingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BindingTests = [
        ("testConvertFromTSDKString", testConvertFromTSDKString),
        ("testConvertToTSDKString", testConvertToTSDKString),
        ("testRequestLibraryAsync", testRequestLibraryAsync),
    ]
}

extension TonClientSwiftTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TonClientSwiftTests = [
        ("testExample", testExample),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BindingTests.__allTests__BindingTests),
        testCase(TonClientSwiftTests.__allTests__TonClientSwiftTests),
    ]
}
#endif
