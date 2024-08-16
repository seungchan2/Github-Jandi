//
//  LoginView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/2/24.
//

import Combine
import SwiftUI

import ComposableArchitecture

struct GithubLoginView: View {
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.isLoggedIn {
                    Text("Logged In")
                } else {
                    Button("Login with GitHub") {
                        viewStore.send(.loginButtonTapped)
                    }
                }
            }
            .onOpenURL { url in
                viewStore.send(.handleOpenURL(url))
            }
        }
    }
}
