//
//  BackgroundTabBar.swift
//  shoppingList
//
//  Created by Rebecca Nußbaumer on 05.04.24.
//

import SwiftUI

struct BackgroundTabBar: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 15)
            .background(Color.white.opacity(0.7))
    }
}
#Preview {
    BackgroundTabBar()
}
