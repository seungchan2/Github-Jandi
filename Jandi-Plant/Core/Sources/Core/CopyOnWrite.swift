//
//  CopyOnWrite.swift
//  
//
//  Created by MEGA_Mac on 8/21/24.
//

import Foundation

@propertyWrapper
public struct CopyOnWrite<T> {
    private final class Ref {
        var val: T
        init(_ v: T) { val = v }
    }
    private var ref: Ref

    public init(wrappedValue: T) { ref = Ref(wrappedValue) }
    
    public var wrappedValue: T {
        get { ref.val }
        set {
            if !isKnownUniquelyReferenced(&ref) {
                ref = Ref(newValue)
                return
            }
            ref.val = newValue
        }
    }
}

extension CopyOnWrite: Equatable where T: Equatable {
    public static func == (lhs: CopyOnWrite<T>, rhs: CopyOnWrite<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension CopyOnWrite: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

extension CopyOnWrite: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(T.self)
        self = CopyOnWrite(wrappedValue: value)
    }
}

extension CopyOnWrite: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
