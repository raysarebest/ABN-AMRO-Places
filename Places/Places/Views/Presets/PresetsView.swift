//
//  PresetsView.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import SwiftUI

struct PresetsView: View {
    
    @Environment(\.loadData) private var loadData
    @State private var locations: Result<[Location], any Error>? = nil
    
    var body: some View {
        switch locations {
            case .none:
            
                // No data downloaded yet, gotta wait for it
            
                ProgressView()
                    .task(refresh)
            
            case .some(let result):
            
                // Data fetched successfully, analyze and display it
            
                PresetsDataView(presets: result)
                    .refreshable(action: refresh)
        }
    }
    
    @Sendable private func refresh() async {
        do {
            locations = .success(try await loadData())
        }
        catch let error {
            locations = .failure(error)
        }
    }
}

#Preview {
    PresetsView()
}
