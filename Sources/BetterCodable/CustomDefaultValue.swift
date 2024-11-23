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