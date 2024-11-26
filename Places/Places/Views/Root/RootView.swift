//
//  RootView.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            PresetsView()
                .tabItem {
                    Label("root.tab.presets-name", systemImage: "list.bullet")
                }
            CustomLocationView()
                .tabItem {
                    Label("root.tab.custom-name", systemImage: "map.fill")
                }
        }
    }
}

#Preview {
    RootView()
}
