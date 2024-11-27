//
//  PlacesApp.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import SwiftUI

@main
struct PlacesApp: App {
    
    static let dataLoader = DataLoader(networker: URLSession.shared)
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .dataLoader(Self.dataLoader)
        }
    }
}
