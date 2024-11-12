public struct DefaultEmptyArrayStrategy<T: Decodable>: DefaultCodableStrategy {
    public static var defaultValue: [T] { return [] }
}

/// Decodes Arrays returning an empty array instead of nil if applicable
///
/// `@DefaultEmptyArray` decodes Arrays and returns an empty array instead of nil if the Decoder is unable to decode the
/// container.
public typealias DefaultEmptyArray<T> = DefaultCodable<DefaultEmptyArrayStrategy<T>> where T: Decodable


public protocol StringCodableStrategy: DefaultCodableStrategy where DefaultValue == String {}

public struct DefaultEmptyStingStrategy: StringCodableStrategy {
    public static var defaultValue: String { return "" }
}

public typealias DefaultEmptyString = DefaultCodable<DefaultEmptyStingStrategy>
