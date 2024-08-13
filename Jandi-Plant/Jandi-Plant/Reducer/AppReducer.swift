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
struct AppReducer {
    struct State: Equatable {
        var loginState = LoginReducer.State()
        var homeState: HomeReducer.State? = nil
        var isLoggedIn: Bool = UserDefaults.standard.string(forKey: "accessToken") != nil
    }
    
    public enum Action: Equatable {
        case login(LoginReducer.Action)
        case home(HomeReducer.Action)
        case checkLoginStatus
        case navigateToHome
        case handleOpenURL(URL)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .login(.requestAccessToken(.success(_))):
                state.isLoggedIn = true
                state.homeState = HomeReducer.State()
                return .none
            case .login:
                return .none
            case .home:
                return .none
            case .checkLoginStatus:
                state.isLoggedIn = !JandiUserDefault.accessToken.isEmpty
                if state.isLoggedIn {
                    state.homeState = HomeReducer.State()
                }
                return .none
            case .navigateToHome:
                state.homeState = HomeReducer.State()
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
        .ifLet(\.homeState, action: \.home) {
            HomeReducer()
        }
        Scope(state: \.loginState, action: \.login) {
            LoginReducer()
        }
    }
}
