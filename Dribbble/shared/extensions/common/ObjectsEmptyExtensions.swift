//
//  ObjectsEmptyExtensions.swift
//  Tavern
//
//  Created by Lobanov on 13.10.15.
//  Copyright © 2015 Lobanov Aleksey. All rights reserved.
//

extension Optional {
    var hasValue: Bool {
        switch self {
        case .none:
            return false
        case .some(_):
            return true
        }
    }
}

extension String {
    func toUInt() -> UInt? {
        return UInt(self)
    }
    
    func toUIntWithDefault(_ defaultValue: UInt) -> UInt {
        return UInt(self) ?? defaultValue
    }
}

// Anything that can hold a value (strings, arrays, etc)
protocol Occupiable {
    var isEmpty: Bool { get }
    var isNotEmpty: Bool { get }
}

// Give a default implementation of isNotEmpty, so conformance only requires one implementation
extension Occupiable {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String: Occupiable { }

// I can't think of a way to combine these collection types. Suggestions welcome.
extension Array: Occupiable { }
extension Dictionary: Occupiable { }
extension Set: Occupiable { }

// Extend the idea of occupiability to optionals. Specifically, optionals wrapping occupiable things.
extension Optional where Wrapped: Occupiable {
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isEmpty
        }
    }
    
    var isNotNilNotEmpty: Bool {
        return !isNilOrEmpty
    }
}

extension RangeReplaceableCollection where Iterator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object: Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}
