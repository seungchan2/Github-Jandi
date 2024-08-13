//
//  UserDefault.swift
//  
//
//  Created by MEGA_Mac on 8/12/24.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    public let defaultValue: T

    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


public struct JandiUserDefault {
    @UserDefault(key: "accessToken", defaultValue: "")
    public static var accessToken: String
    
    @UserDefault(key: "selectedTheme", defaultValue: ["crownLow"])
    public static var selectedTheme: [String]
    
    @UserDefault(key: "coin", defaultValue: 0)
    public static var coin: Int
    
    public init() {}
}
