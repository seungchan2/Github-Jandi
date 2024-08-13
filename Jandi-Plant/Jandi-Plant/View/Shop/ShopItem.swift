//
//  ShopItemView.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/12/24.
//

import SwiftUI

struct ShopItem: View {
    var themeType: ThemeType
    var isSelected: Bool
    var onSelect: () -> Void
    var onLockedTheme: () -> Void
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<themeType.theme.count, id: \.self) { index in
                VStack {
                    Image(themeType.theme[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            }
            Spacer()
            VStack(spacing: 4) {
                Text("\(themeType.price) commit days")
                    .font(.pretendardB(15))
                    .foregroundColor(.black)
                LockedStateView(isLocked: themeType.isLocked)
            }
        }
        .modifier(ShopItemModifier(isSelected: isSelected, isLocked: themeType.isLocked))
        .onTapGesture {
            if themeType.isLocked {
                onLockedTheme()
            } else {
                onSelect()
            }
        }
    }
}

struct ShopItemModifier: ViewModifier {
    var isSelected: Bool
    var isLocked: Bool

    func body(content: Content) -> some View {
        content
            .padding()
            .background(isSelected ? Color.green.opacity(0.2) : (isLocked ? Color.black.opacity(0.35) : Color.white))
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

struct LockedStateView: View {
    var isLocked: Bool

    var body: some View {
        if isLocked {
            Image("icLock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.black)
                .opacity(0.3)
        } else {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
}
