//
//  Binding.swift
//  SQift
//
//  Created by Christian Noon on 11/8/15.
//  Copyright © 2015 Nike. All rights reserved.
//

import Foundation

/// Used to store a `Bindable` value representation prior to binding a parameter to a `Statement`.
///
/// For more information about parameter binding, please refer to the 
/// [documentation](https://www.sqlite.org/c3ref/bind_blob.html).
///
/// - null:    Represents a `NULL` value to bind to a `Statement` using `sqlite3_bind_null`.
/// - integer: Represents a `INTEGER` value to bind to a `Statement` using `sqlite3_bind_int64`.
/// - real:    Represents a `REAL` value to bind to a `Statement` using `sqlite3_bind_double`.
/// - text:    Represents a `TEXT` value to bind to a `Statement` using `sqlite3_bind_text`.
/// - blob:    Represents a `BLOB` value to bind to a `Statement` using `sqlite3_bind_blob`.
public enum BindingValue {
    case null
    case integer(Int64)
    case real(Double)
    case text(String)
    case blob(Data)
}

extension BindingValue: Equatable {}

/// Returns whether the lhs and rhs `BindingValue` instances are equal.
///
/// - Parameters:
///   - lhs: The left-hand side `BindingValue` instance to compare.
///   - rhs: The right-hand side `BindingValue` instance to compare.
///
/// - Returns: `true` if the two instances are equal, `false` otherwise.
public func ==(lhs: BindingValue, rhs: BindingValue) -> Bool {
    switch (lhs, rhs) {
    case (.null, .null):
        return true

    case let (.integer(lhsValue), .integer(rhsValue)):
        return lhsValue == rhsValue

    case let (.real(lhsValue), .real(rhsValue)):
        return lhsValue == rhsValue

    case let (.text(lhsValue), .text(rhsValue)):
        return lhsValue == rhsValue

    case let (.blob(lhsValue), .blob(rhsValue)):
        return lhsValue == rhsValue

    default:
        return false
    }
}

/// The `Bindable` protocol represents any type that can be bound to a `Statement` as a parameter.
public protocol Bindable {
    /// The binding value representation of the type to be bound to a `Statement`.
    var bindingValue: BindingValue { get }
}

/// The `Extractable` protocol represents any type that can be extracted from the `Database`.
public protocol Extractable {
    /// The binding type of a parameter to bind to a statement.
    associatedtype BindingType

    /// The data type of the object to convert to after extracting an object from the database.
    associatedtype DataType = Self

    /// Converts the binding value `Any` representation into an equivalent `DataType` representation if possible.
    static func fromBindingValue(_ value: Any) -> DataType?
}

/// The `Binding` protocol represents a type that is both `Bindable` as a parameter and `Extractable` from the database.
public protocol Binding: Bindable, Extractable {}

// MARK: - Null Bindable

extension NSNull: Bindable {
    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .null }
}

// MARK: - Integer Bindings

extension Bool: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self ? 1 : 0)) }

    /// Converts the binding value `Any` object representation to an equivalent `Bool` representation.
    public static func fromBindingValue(_ value: Any) -> Bool? {
        guard let value = value as? Int64 else { return nil }
        return value != 0
    }
}

extension Int8: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `Int8` representation.
    public static func fromBindingValue(_ value: Any) -> Int8? {
        guard let value = value as? Int64 else { return nil }

        guard value >= Int64(Int8.min) else { return Int8.min }
        guard value <= Int64(Int8.max) else { return Int8.max }

        return Int8(value)
    }
}

extension Int16: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `Int16` representation.
    public static func fromBindingValue(_ value: Any) -> Int16? {
        guard let value = value as? Int64 else { return nil }

        guard value >= Int64(Int16.min) else { return Int16.min }
        guard value <= Int64(Int16.max) else { return Int16.max }

        return Int16(value)
    }
}

extension Int32: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `Int32` representation.
    public static func fromBindingValue(_ value: Any) -> Int32? {
        guard let value = value as? Int64 else { return nil }

        guard value >= Int64(Int32.min) else { return Int32.min }
        guard value <= Int64(Int32.max) else { return Int32.max }

        return Int32(value)
    }
}

extension Int64: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(self) }

    /// Converts the binding value `Any` object representation to an equivalent `Int64` representation.
    public static func fromBindingValue(_ value: Any) -> Int64? {
        return value as? Int64
    }
}

extension Int: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `Int` representation.
    public static func fromBindingValue(_ value: Any) -> Int? {
        guard let value = value as? Int64 else { return nil }

        guard value >= Int64(Int.min) else { return Int.min }
        guard value <= Int64(Int.max) else { return Int.max }

        return Int(value)
    }
}

extension UInt8: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `Int8` representation.
    public static func fromBindingValue(_ value: Any) -> UInt8? {
        guard let value = value as? Int64 else { return nil }

        guard value >= Int64(UInt8.min) else { return UInt8.min }
        guard value <= Int64(UInt8.max) else { return UInt8.max }

        return UInt8(value)
    }
}

extension UInt16: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `UInt16` representation.
    public static func fromBindingValue(_ value: Any) -> UInt16? {
        guard let value = value as? Int64 else { return nil }

        guard value >= Int64(UInt16.min) else { return UInt16.min }
        guard value <= Int64(UInt16.max) else { return UInt16.max }

        return UInt16(value)
    }
}

extension UInt32: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `UInt32` representation.
    public static func fromBindingValue(_ value: Any) -> UInt32? {
        guard let value = value as? Int64 else { return nil }

        guard value >= Int64(UInt32.min) else { return UInt32.min }
        guard value <= Int64(UInt32.max) else { return UInt32.max }

        return UInt32(value)
    }
}

extension UInt64: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(bitPattern: self)) }

    /// Converts the binding value `Any` object representation to an equivalent `UInt64` representation.
    public static func fromBindingValue(_ value: Any) -> UInt64? {
        guard let value = value as? Int64 else { return nil }
        return UInt64(bitPattern: value)
    }
}

extension UInt: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Int64

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .integer(Int64(bitPattern: UInt64(self))) }

    /// Converts the binding value `Any` object representation to an equivalent `UInt` representation.
    public static func fromBindingValue(_ value: Any) -> UInt? {
        guard let value = value as? Int64 else { return nil }
        return UInt(UInt64(bitPattern: value))
    }
}

// MARK: - Real Bindings

extension Float: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Double

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .real(Double(self)) }

    /// Converts the binding value `Any` object representation to an equivalent `Float` representation.
    public static func fromBindingValue(_ value: Any) -> Float? {
        guard let value = value as? Double else { return nil }
        return Float(value)
    }
}

extension Double: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Double

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .real(self) }

    /// Converts the binding value `Any` object representation to an equivalent `Double` representation.
    public static func fromBindingValue(_ value: Any) -> Double? {
        return value as? Double
    }
}

// MARK: - Text Bindings

extension String: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = String

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .text(self) }

    /// Converts the binding value `Any` object representation to an equivalent `String` representation.
    public static func fromBindingValue(_ value: Any) -> String? {
        return value as? String
    }
}

extension URL: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = String

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .text(absoluteString) }

    /// Converts the binding value `Any` object representation to an equivalent `URL` representation.
    public static func fromBindingValue(_ value: Any) -> URL? {
        guard let value = value as? String else { return nil }
        return URL(string: value)
    }
}

extension Date: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = String

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .text(bindingDateFormatter.string(from: self)) }

    /// Converts the binding value `Any` object representation to an equivalent `Date` representation.
    public static func fromBindingValue(_ value: Any) -> Date? {
        guard let value = value as? String else { return nil }
        return bindingDateFormatter.date(from: value)
    }
}

/// Global date formatter to allow the `Date` binding to read and write dates as strings in the database. This makes
/// dates much more human readable and also works with all SQLite date functionality.
///
/// For more information, please refer to the [documentation](https://www.sqlite.org/lang_datefunc.html).
public var bindingDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    return formatter
}()

// MARK: - Blob Bindings

extension Data: Binding {
    /// The binding type of a parameter to bind to a statement.
    public typealias BindingType = Data

    /// The binding value representation of the type to be bound to a `Statement`.
    public var bindingValue: BindingValue { return .blob(self) }

    /// Converts the binding value `Any` object representation to an equivalent `Data` representation.
    public static func fromBindingValue(_ value: Any) -> Data? {
        return value as? Data
    }
}
