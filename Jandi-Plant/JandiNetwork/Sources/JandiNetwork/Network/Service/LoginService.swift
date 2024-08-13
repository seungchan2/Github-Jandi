//
//  LoginService.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/5/24.
//

import Combine
import UIKit

import Dependencies
import SwiftSoup

public protocol LoginServiceType {
    func requestCode() -> String
    func fetchAccessToken(with code: String) -> AnyPublisher<String, Error>
}

public final class LoginService: LoginServiceType {
    
    private let scope: String = ""
    private let githubURL: String = "https://github.com"
    
    public init() {}
    
    public func requestCode() -> String {
        var urlCode = ""
        var components = URLComponents(string: githubURL+"/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.client_id),
            URLQueryItem(name: "scope", value: self.scope),
        ]
        
        let urlString = components.url?.absoluteString
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
            let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
                urlCode = code
            }
            return urlCode
        }
        return urlCode
    }
    
    public func fetchAccessToken(with code: String) -> AnyPublisher<String, Error> {
        let parameters = ["client_id": client_id,
                          "client_secret": client_secret,
                          "code": code]
        
        var components = URLComponents(string: githubURL+"/login/oauth/access_token")!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> String in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let accessTokenResponse = try JSONDecoder().decode(AccessTokenResponse.self, from: data)
                return accessTokenResponse.access_token
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension LoginService: DependencyKey {
    public static var liveValue = LoginService()
}
