//
//  NetworkRequest.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Foundation

public struct NetworkRequest {
    public let url: String
    public let headers: [String: String]
    public let httpMethod: HTTPMethod
}
