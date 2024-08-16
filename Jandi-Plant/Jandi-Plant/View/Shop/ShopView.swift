//
//  ShopView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/7/24.
//

import SwiftUI

import Core
import JandiNetwork

import ComposableArchitecture

struct ThemeType: Identifiable, Equatable, Codable {
    var id = UUID()
    var price: Int
    var isLocked: Bool
    var theme: [String]
}

struct ShopView: View {
    let store: StoreOf<ShopFeature>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewStore.themes) { theme in
                            ShopItem(themeType: theme,
                                     isSelected: theme.id == viewStore.selectedThemeID,
                                     onSelect: {
                                viewStore.send(.setSelectedThemeID(theme.id))
                                JandiUserDefault.selectedTheme = theme.theme
                            },
                                     onLockedTheme: {
                                viewStore.send(.themeTapped(theme.id))
                            })
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .navigationBarItems(leading: BackButton(action: {
                    presentationMode.wrappedValue.dismiss()
                }))
            }
            .alert(
                isPresented: viewStore.binding(
                    get: \.showAlert,
                    send: .dismissAlert
                ),
                content: {
                    purchaseAlert(viewStore: viewStore)
                }
            )
            .onAppear {
                viewStore.send(.loadPurchasedThemes)
                loadSavedTheme(viewStore: viewStore)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private extension ShopView {
    func purchaseAlert(viewStore: ViewStore<ShopFeature.State, ShopFeature.Action>) -> Alert {
        return Alert(
            title: Text("해당 이모티콘을 잠금 해제하시겠습니까?"),
            message: Text(
                """
                현재 커밋 일 수: \(JandiUserDefault.coin)
                \(viewStore.alertTheme?.price ?? 0)일 의 커밋이 필요합니다.
                """
            ),
            primaryButton: .default(Text("구매"), action: {
                viewStore.send(.confirmPurchase)
            }),
            secondaryButton: .cancel(Text("취소"))
        )
    }
    
    func loadSavedTheme(viewStore: ViewStore<ShopFeature.State, ShopFeature.Action>) {
        let savedTheme = JandiUserDefault.selectedTheme
        if let theme = viewStore.themes.first(where: { $0.theme == savedTheme }) {
            viewStore.send(.setSelectedThemeID(theme.id))
        }
    }
}
