//
//  CustomCodableStrategy.swift
//  BetterCodable
//
//  Created by karimzhang on 11/11/24.
//

import Foundation

public protocol IntCodableStrategy: DefaultCodableStrategy where DefaultValue == Int {}
public protocol Int32CodableStrategy: DefaultCodableStrategy where DefaultValue == Int32 {}
public protocol DoubleCodableStrategy: DefaultCodableStrategy where DefaultValue == Double {}
public protocol FloatCodableStrategy: DefaultCodableStrategy where DefaultValue == Float {}

public extension KeyedDecodingContainer {
    func decode<P: IntCodableStrategy>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        do {
            let value = try decode(Int.self, forKey: key)
            return DefaultCodable(wrappedValue: value)
        } catch let error {
            guard let decodingError = error as? DecodingError,
                  case .typeMismatch = decodingError else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
            if let boolValue = try? decodeIfPresent(Bool.self, forKey: key) {
                return DefaultCodable(wrappedValue: boolValue ? 1 : 0)
            } else if let doubleValue = try? decodeIfPresent(Double.self, forKey: key) {
                return DefaultCodable(wrappedValue: Int(doubleValue))
            } else if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
                if let intValue = Int(stringValue) {
                    return DefaultCodable(wrappedValue: intValue)
                } else if let doubleValue = Double(stringValue) {
                    return DefaultCodable(wrappedValue: Int(doubleValue))
                } else {
                    return DefaultCodable(wrappedValue: P.defaultValue)
                }
            } else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
        }
    }
}


public extension KeyedDecodingContainer {
    func decode<P: DoubleCodableStrategy>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        do {
            let value = try decode(Double.self, forKey: key)
            return DefaultCodable(wrappedValue: value)
        } catch let error {
            guard let decodingError = error as? DecodingError,
                  case .typeMismatch = decodingError else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
            if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
                return DefaultCodable(wrappedValue: Double(intValue))
            } else if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
                if let doubleValue = Double(stringValue) {
                    return DefaultCodable(wrappedValue: doubleValue)
                } else if let intValue = Int(stringValue) {
                    return DefaultCodable(wrappedValue: Double(intValue))
                } else {
                    return DefaultCodable(wrappedValue: P.defaultValue)
                }
            } else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
        }
    }
}


public extension KeyedDecodingContainer {
    func decode<P: FloatCodableStrategy>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        do {
            let value = try decode(Float.self, forKey: key)
            return DefaultCodable(wrappedValue: value)
        } catch let error {
            guard let decodingError = error as? DecodingError,
                  case .typeMismatch = decodingError else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
            if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
                return DefaultCodable(wrappedValue: Float(intValue))
            } else if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
                if let floatValue = Float(stringValue) {
                    return DefaultCodable(wrappedValue: floatValue)
                } else if let intValue = Int(stringValue) {
                    return DefaultCodable(wrappedValue: Float(intValue))
                } else {
                    return DefaultCodable(wrappedValue: P.defaultValue)
                }
            } else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
        }
    }
}
