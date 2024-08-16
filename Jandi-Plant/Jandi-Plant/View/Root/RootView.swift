//
//  RootView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/5/24.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group {
                if viewStore.isLoggedIn {
                    HomeView(store: store.scope(state: \.homeState, action: \.home))
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
