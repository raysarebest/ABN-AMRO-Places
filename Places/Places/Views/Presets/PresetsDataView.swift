//
//  PresetsDataView.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import SwiftUI

struct PresetsDataView: View {
    
    @Environment(\.refresh) private var refresh
    let presets: Result<[Location], any Error>
    
    var body: some View {
        switch presets {
            case .failure(let error):
                RefreshableContentUnavailableView(title: "presets.error.not-available.title", symbolName: "exclamationmark.triangle.fill", error: error)
            case .success(let locations):
                if locations.isEmpty {
                   RefreshableContentUnavailableView(title: "presets.empty.not-available.title", symbolName: "mappin.slash")
                }
                else {
                    PresetsListView(locations: locations)
                }
        }
    }
}

#if DEBUG

#Preview("Error") {
    PresetsDataView(presets: .failure(DummyError.example))
        .refreshable {}
}

#Preview("Empty") {
    PresetsDataView(presets: .success([]))
        .refreshable {}
}

#Preview("Valid Data") {
    PresetsDataView(presets: .success(.preview))
        .refreshable {}
}
#endif
