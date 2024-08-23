//
//  LoginReducer.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/5/24.
//

import Combine
import UIKit

import Core
import JandiNetwork

import Dependencies
import ComposableArchitecture

@Reducer
struct LoginFeature {
    struct State: Equatable {
        var isLoggedIn: Bool = !JandiUserDefault.accessToken.isEmpty
    }
    
    enum Action: Equatable {
        case loginButtonTapped
        case fetchGithubLogin(TaskResult<String>)
        case requestAccessToken(TaskResult<String>)
        case handleOpenURL(URL)
    }
    
    @Dependency(\.loginService) var loginService
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                return self.loginButtonTapped()
                
            case let .fetchGithubLogin(.success(code)):
                return self.fetchGithubLoginSuccess(code)
                
            case .fetchGithubLogin(.failure(_)):
                return .none
                
            case let .requestAccessToken(.success(token)):
                return self.requestAccessTokenSuccess(token, state: &state)
                
            case .requestAccessToken(.failure(_)):
                return .none
                
            case .handleOpenURL(let url):
                return self.openURL(url)
            }
        }
    }
    
    private func loginButtonTapped() -> Effect<Action> {
        return .run { send in
            await send(.fetchGithubLogin(
                TaskResult {
                    loginService.requestCode()
                })
            )
        }
    }
    
    private func fetchGithubLoginSuccess(_ code: String) -> Effect<Action> {
        return .run { send in
            let token = loginService.fetchAccessToken(with: code)
                .map { Action.requestAccessToken(.success($0)) }
                .catch { Just(Action.requestAccessToken(.failure($0))) }
                .receive(on: DispatchQueue.main)
            
            for await result in token.values {
                await send(result)
            }
        }
    }
    
    private func requestAccessTokenSuccess(_ token: String, state: inout State) -> Effect<Action> {
        JandiUserDefault.accessToken = token
        state.isLoggedIn = true
        return .none
    }
    
    private func openURL(_ url: URL) -> Effect<Action> {
        let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
        return .run { send in
            await send(.fetchGithubLogin(
                TaskResult { code }
            ))
        }
    }
}
