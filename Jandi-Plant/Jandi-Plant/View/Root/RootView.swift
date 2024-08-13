//
//  RootView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/5/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<AppReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.isLoggedIn {
                    IfLetStore(
                        self.store.scope(state: \.homeState, action: \.home),
                        then: HomeView.init(store:)
                    )
                } else {
                    GithubLoginView(store: store.scope(state: \.loginState, action: \.login))
                }
            }
            .onOpenURL { url in
                viewStore.send(.handleOpenURL(url))
            }
        }
        .onAppear {
            store.send(.checkLoginStatus)
        }
    }
}
