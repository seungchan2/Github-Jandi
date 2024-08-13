//
//  BackButton.swift
//  Jandi-Plant
//
//  Created by MEGA_Mac on 8/12/24.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("icBack")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
            }
        }
    }
}
