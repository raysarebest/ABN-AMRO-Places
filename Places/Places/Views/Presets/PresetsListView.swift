//
//  PresetsListView.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import SwiftUI

struct PresetsListView: View {
    
    let locations: [Location]
    
    var body: some View {
        List {
            ForEach(Array(locations.lazy.enumerated()), id: \.offset) { _, location in
                PresetsListViewRow(location: location)
            }
        }
    }
}

#if DEBUG

#Preview {
    PresetsListView(locations: .preview)
}

#endif
