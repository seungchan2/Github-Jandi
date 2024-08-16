//
//  Jandi_PlantApp.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/2/24.
//

import SwiftUI

import ComposableArchitecture

@main
struct Jandi_PlantApp: App {
    init() {
        FontType.install()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: AppFeature.State(),
                                  reducer: { AppFeature() })
            )
        }
    }
}
