//
//  LoadData.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import SwiftUI

private struct LoadDataKey: EnvironmentKey {
    static let defaultValue = DataLoader(networker: URLSession.shared)
}

extension EnvironmentValues {
    var loadData: DataLoader {
        get {
            return self[LoadDataKey.self]
        }
        
        set {
            self[LoadDataKey.self] = newValue
        }
    }
}

extension View {
    @ViewBuilder func dataLoader(_ loader: DataLoader) -> some View {
        environment(\.loadData, loader)
    }
}
