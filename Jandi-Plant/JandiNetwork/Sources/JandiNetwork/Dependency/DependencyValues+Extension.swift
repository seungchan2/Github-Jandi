//
//  DependencyValues.swift
//
//
//  Created by MEGA_Mac on 8/8/24.
//

import Dependencies

extension DependencyValues {
    public var loginService: LoginService {
        get { self[LoginService.self] }
        set { self[LoginService.self] = newValue }
    }
    
    public var githubService: GithubService {
        get { self[GithubService.self] }
        set { self[GithubService.self] = newValue }
    }
}
