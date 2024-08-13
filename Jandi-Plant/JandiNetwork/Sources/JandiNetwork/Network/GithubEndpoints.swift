//
//  GithubEndpoints.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import Foundation

import Core

public enum GithubServiceEndpoints {
    case getCommits(id: String, year: Int)
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getCommits:
            return .GET
        }
    }
    
    public func getURL() -> String {
        switch self {
        case .getCommits(let id, let year):
            return "https://github.com/users/\(id)/contributions?from=\(year)-01-01&to=\(year)-12-31"
        }
    }
    
    public func createRequest(token: String = "") -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(JandiUserDefault.accessToken)"
        return NetworkRequest(url: getURL(),
                              headers: headers,
                              httpMethod: httpMethod)
    }
}
