//
//  CustomDefaultValue.swift
//  BetterCodable
//
//  Created by karimzhang on 11/11/24.
//

import Foundation


public struct DefaultZeroStrategy: IntCodableStrategy {
    public static var defaultValue: Int { return 0 }
}

public typealias DefaultZero = DefaultCodable<DefaultZeroStrategy>

public struct DefaultZeroInt32Strategy: Int32CodableStrategy {
    public static var defaultValue: Int32 { return 0 }
}

public typealias DefaultZeroInt32 = DefaultCodable<DefaultZeroInt32Strategy>

public struct DefaultZeroDoubleStrategy: DoubleCodableStrategy {
    public static var defaultValue: Double { return 0 }
}

public typealias DefaultZeroDouble = DefaultCodable<DefaultZeroDoubleStrategy>


public struct DefaultZeroFloatStrategy: FloatCodableStrategy {
    public static var defaultValue: Float { return 0 }
}

public typealias DefaultZeroFloat = DefaultCodable<DefaultZeroFloatStrategy>


@propertyWrapper
public struct Default<T: Decodable> {
    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        guard let value = try? container.decode(T.self) else {
            guard let stringValue = try? container.decode(String.self) else {
                self.wrappedValue = Self.defaultValue
                return
            }
            switch T.self {
            case is Int.Type:
                if let tmpValue = Int(stringValue) {
                    self.wrappedValue = tmpValue as! T
                    return
                }
            case is Double.Type:
                if let tmpValue = Double(stringValue) {
                    self.wrappedValue = tmpValue as! T
                    return
                }
            default:
                fatalError("Unsupported type")
            }
            self.wrappedValue = Self.defaultValue
            return
        }
        self.wrappedValue = value

        
    }

    private static var defaultValue: T {
        switch T.self {
        case is Int.Type:
            return 0 as! T
        case is String.Type:
            return "" as! T
        case is Double.Type:
            return 0 as! T
        case is Bool.Type:
            return false as! T
        default:
            fatalError("Unsupported type")
        }
    }
}

extension Default: Decodable {}
