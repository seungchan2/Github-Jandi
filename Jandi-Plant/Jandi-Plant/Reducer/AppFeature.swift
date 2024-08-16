//
//  AppReducer.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/5/24.
//

import Foundation

import Core
import JandiNetwork

import ComposableArchitecture

@Reducer
struct AppFeature {
    struct State: Equatable {
        var loginState = LoginFeature.State()
        var homeState = HomeFeature.State()
        var isLoggedIn: Bool = UserDefaults.standard.string(forKey: "accessToken") != nil
    }
    
    public enum Action: Equatable {
        case login(LoginFeature.Action)
        case home(HomeFeature.Action)
        case checkLoginStatus
        case navigateToHome
        case handleOpenURL(URL)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.homeState, action: \.home) {
            HomeFeature()
        }
        
        Scope(state: \.loginState, action: \.login) {
            LoginFeature()
        }
        Reduce { state, action in
            switch action {
            case .login(.requestAccessToken(.success(_))):
                state.isLoggedIn = true
                state.homeState = HomeFeature.State()
                return .none
            case .login:
                return .none
            case .home:
                return .none
            case .checkLoginStatus:
                state.isLoggedIn = !JandiUserDefault.accessToken.isEmpty
                if state.isLoggedIn {
                    state.homeState = HomeFeature.State()
                }
                return .none
            case .navigateToHome:
                state.homeState = HomeFeature.State()
                return .none
            case let .handleOpenURL(url):
                let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
                return .run { send in
                    await send(.login(.fetchGithubLogin(
                        TaskResult {
                            code
                        }
                    )))
                }
            }
        }
        
    }
}
