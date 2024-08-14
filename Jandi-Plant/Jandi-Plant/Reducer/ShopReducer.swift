//
//  ShopReducer.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/9/24.
//

import Foundation

import Core

import ComposableArchitecture

@Reducer
struct ShopReducer {
    struct State: Equatable {
        var themes: [ThemeType] = []
        var selectedThemeID: UUID?
        var showAlert: Bool = false
        var alertTheme: ThemeType?
        var showErrorAlert: Bool = false
        var errorMessage: String?
    }
    
    enum Action: Equatable {
        case themeTapped(UUID)
        case confirmPurchase
        case dismissAlert
        case setSelectedThemeID(UUID?)
        case showError(String)
        case loadPurchasedThemes
        case unlockThemesBasedOnCoins
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .themeTapped(let themeID):
            themeTapped(themeID: themeID, state: &state)
            return .none
            
        case .confirmPurchase:
            confirmPurchase(state: &state)
            return .send(.loadPurchasedThemes)
            
        case .dismissAlert:
            dismissAlert(state: &state)
            return .none
            
        case let .setSelectedThemeID(id):
            setSelectedThemeID(id: id, state: &state)
            return .none
            
        case let .showError(message):
            showError(message: message, state: &state)
            return .none
            
        case .loadPurchasedThemes:
            loadPurchasedThemes(state: &state)
            return .none
            
        case .unlockThemesBasedOnCoins:
            unlockThemesBasedOnCoins(state: &state)
            return .none
        }
    }
    
    private func themeTapped(themeID: UUID, state: inout State) {
        if let selectedTheme = state.themes.first(where: { $0.id == themeID }) {
            if selectedTheme.isLocked {
                state.alertTheme = selectedTheme
                state.showAlert = true
            }
        }
    }
    
    private func confirmPurchase(state: inout State) {
        guard let alertTheme = state.alertTheme else { return }
        let currentCoins = JandiUserDefault.coin
        if currentCoins >= alertTheme.price {
            state.selectedThemeID = alertTheme.id
            JandiUserDefault.selectedTheme = alertTheme.theme            
            if let index = state.themes.firstIndex(where: { $0.id == alertTheme.id }) {
                state.themes[index].isLocked = false
                if let savedThemesData = try? JSONEncoder().encode(state.themes) {
                    UserDefaults.standard.set(savedThemesData, forKey: "savedThemes")
                }
            }
        } else {
            state.showErrorAlert = true
            state.errorMessage = "코인이 부족합니다."
        }
        state.showAlert = false
    }
    
    private func dismissAlert(state: inout State) {
        state.showAlert = false
        state.showErrorAlert = false
    }
    
    private func setSelectedThemeID(id: UUID?, state: inout State) {
        state.selectedThemeID = id
    }
    
    private func showError(message: String, state: inout State) {
        state.errorMessage = message
        state.showErrorAlert = true
    }
    
    private func loadPurchasedThemes(state: inout State) {
        if let savedThemesData = UserDefaults.standard.data(forKey: "savedThemes"),
           let savedThemes = try? JSONDecoder().decode([ThemeType].self, from: savedThemesData) {
            state.themes = savedThemes
        } else {
            state.themes = [
                ThemeType(price: 10,
                          isLocked: false,
                          theme: ["smileL", "smileL", "smileM", "smileH", "smileVH"]),
                ThemeType(price: 30,
                          isLocked: true,
                          theme: ["surpriseL", "surpriseL", "surpriseM", "surpriseH", "surpriseVH"]),
                ThemeType(price: 30,
                          isLocked: true,
                          theme: ["surprisePinkL", "surprisePinkL", "surprisePinkM", "surprisePinkH", "surprisePinkVH"]),
                ThemeType(price: 50,
                          isLocked: true,
                          theme: ["crownL", "crownL", "crownM", "crownH", "crownVH"]),
                ThemeType(price: 50,
                          isLocked: true,
                          theme: ["crownPinkL", "crownPinkL", "crownPinkM", "crownPinkH", "crownPinkVH"]),
                ThemeType(price: 50,
                          isLocked: true,
                          theme: ["loveL", "loveL", "loveM", "loveH", "loveVH"]),
                ThemeType(price: 50,
                          isLocked: true,
                          theme: ["lovePinkL", "lovePinkL", "lovePinkM", "lovePinkH", "lovePinkVH"]),
                ThemeType(price: 70,
                          isLocked: true,
                          theme: ["heartGreenL", "heartGreenL", "heartGreenM", "heartGreenH", "heartGreenVH"]),
                ThemeType(price: 70,
                          isLocked: true,
                          theme: ["heartL", "heartL", "heartM", "heartH", "heartVH"])
            ]
        }
    }
    
    private func unlockThemesBasedOnCoins(state: inout State) {
        let currentCoins = JandiUserDefault.coin
        for (index, theme) in state.themes.enumerated() {
            if currentCoins >= theme.price {
                state.themes[index].isLocked = false
            }
        }
        if let savedThemesData = try? JSONEncoder().encode(state.themes) {
            UserDefaults.standard.set(savedThemesData, forKey: "savedThemes")
        }
    }
}
