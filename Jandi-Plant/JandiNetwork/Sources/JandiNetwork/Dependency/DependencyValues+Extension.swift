//
//  DependencyValues.swift
//
//
//  Created by MEGA_Mac on 8/8/24.
//

import Dependencies

extension DependencyValues {
    public var loginService: LoginServiceType {
        get { self[LoginService.self] }
        set { self[LoginService.self] = newValue as! LoginService }
    }
    
    public var githubService: GithubServiceType {
        get { self[GithubService.self] }
        set { self[GithubService.self] = newValue as! GithubService }
    }
}
