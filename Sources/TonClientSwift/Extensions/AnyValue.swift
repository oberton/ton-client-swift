//
//  Created by Oleh Hudeichuk on 18.10.2020.
//

import Foundation

public protocol JSONType: Decodable {
    var jsonValue: Any? { get }
}

extension Int: JSONType {
    public var jsonValue: Any? { return self }
}
extension String: JSONType {
    public var jsonValue: Any? { return self }
}
extension Double: JSONType {
    public var jsonValue: Any? { return self }
}
extension Bool: JSONType {
    public var jsonValue: Any? { return self }
}

public struct AnyJSONType: JSONType, Equatable {

    public let jsonValue: Any?

    public init(_ jsonValue: Any) {
        self.jsonValue = jsonValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            jsonValue = intValue
        } else if let stringValue = try? container.decode(String.self) {
            jsonValue = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            jsonValue = boolValue
        } else if let doubleValue = try? container.decode(Double.self) {
            jsonValue = doubleValue
        } else if let doubleValue = try? container.decode(Array<AnyJSONType>.self) {
            jsonValue = doubleValue
        } else if let doubleValue = try? container.decode(Dictionary<String, AnyJSONType>.self) {
            jsonValue = doubleValue
        } else {
            jsonValue = nil
        }
    }

    public static func == (lhs: AnyJSONType, rhs: AnyJSONType) -> Bool {
        if let lhsValue = lhs.jsonValue as? Int, let rhsValue = rhs.jsonValue as? Int {
            return lhsValue == rhsValue
        } else if let lhsValue = lhs.jsonValue as? String, let rhsValue = rhs.jsonValue as? String {
            return lhsValue == rhsValue
        } else if let lhsValue = lhs.jsonValue as? Bool, let rhsValue = rhs.jsonValue as? Bool {
            return lhsValue == rhsValue
        } else if let lhsValue = lhs.jsonValue as? Double, let rhsValue = rhs.jsonValue as? Double {
            return lhsValue == rhsValue
        } else if let lhsValue = lhs.jsonValue as? Array<AnyJSONType>, let rhsValue = rhs.jsonValue as? Array<AnyJSONType> {
            return lhsValue == rhsValue
        } else if let lhsValue = lhs.jsonValue as? Dictionary<String, AnyJSONType>, let rhsValue = rhs.jsonValue as? Dictionary<String, AnyJSONType> {
            return lhsValue == rhsValue
        } else if lhs.jsonValue == nil, rhs.jsonValue == nil {
            return true
        } else {
            return false
        }
    }

    public func toJSON() -> String {
        var result: String = .init()

        if let value = jsonValue as? Int {
            result = String(value)
        } else if let value = jsonValue as? String {
            result = "\"\(value)\""
        } else if let value = jsonValue as? Double {
            result = String(value)
        } else if let value = jsonValue as? Bool {
            result = String(value)
        } else if let value = jsonValue as? [String: AnyJSONType] {
            result.append("{")
            var first: Bool = true
            for (key, val) in value {
                if first {
                    result.append("\"\(key)\": \(val.toJSON())")
                } else {
                    result.append(", \"\(key)\": \(val.toJSON())")
                }
                first = false
            }
            result.append("}")
        } else if let value = jsonValue as? [AnyJSONType] {
            result.append("[")
            var first: Bool = true
            for val in value {
                if first {
                    result.append("\(val.toJSON())")
                } else {
                    result.append(", \(val.toJSON())")
                }
                first = false
            }
            result.append("]")
        } else {
            result = "null"
        }

        return result
    }

    public func toAny() -> Any {
        var result: Any

        if let value = jsonValue as? Int {
            result = value
        } else if let value = jsonValue as? String {
            result = value
        } else if let value = jsonValue as? Double {
            result = value
        } else if let value = jsonValue as? Bool {
            result = value
        } else if let value = jsonValue as? [String: AnyJSONType] {
            var tmpResult: [String: Any] = .init()
            for (key, val) in value {
                tmpResult[key] = val.toAny()
            }
            result = tmpResult
        } else if let value = jsonValue as? [AnyJSONType] {
            var tmpResult: [Any] = .init()
            for val in value {
                tmpResult.append(val.toAny())
            }
            result = tmpResult
        } else {
            fatalError("JSONType toAny convertor error: unknown type \(jsonValue)")
        }

        return result
    }

    public func toDictionary() -> [String: Any]? {
        toAny() as? [String: Any]
    }
}



public enum AnyValue: Decodable, Encodable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String: AnyValue])
    case array([AnyValue])
    case `nil`(Int8?)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .bool(value):
            try container.encode(value)
        case let .string(value):
            try container.encode(value)
        case let .int(value):
            try container.encode(value)
        case let .object(value):
            try container.encode(value)
        case let .array(value):
            try container.encode(value)
        case let .nil(value):
            try container.encode(value)
        case let .double(value):
            try container.encode(value)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: AnyValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([AnyValue].self) {
            self = .array(value)
        } else {
            self = .nil(nil)
//            throw DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
        }
    }
}
