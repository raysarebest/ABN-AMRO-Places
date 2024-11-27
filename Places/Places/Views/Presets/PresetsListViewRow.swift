//
//  PresetsListViewRow.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import SwiftUI
import CoreLocation

struct PresetsListViewRow: View {
    
    let location: Location
    
    var body: some View {
        Link(destination: .wikipediaURL(at: location)) {
            HStack {
                VStack(alignment: .leading) {
                    Group {
                        if let name = location.name {
                            Text(name)
                        }
                        else {
                            Text("presets.anonymous-location.title")
                        }
                    }
                    .font(.headline)
                    .tint(.primary)
                    
                    Text("presets.coordinate.format (latitude: \(location.coordinate.latitude), longitude:  \(location.coordinate.longitude))")
                        .font(.caption)
                        .accessibilityHidden(true)
                }
                .accessibilityValue(Text("presets.location.accessibility.title (latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude))"))
                
                Spacer()
                
                Image(systemName: "chevron.forward")
            }
            .tint(.secondary)
        }
    }
}

#Preview("Amsterdam", traits: .fixedLayout(width: 500, height: 100)) {
        PresetsListViewRow(location: try! Location(name: "Amsterdam", coordinate: CLLocationCoordinate2D(latitude: 52.3547498, longitude: 4.8339215)))
}

#Preview("No Name", traits: .fixedLayout(width: 500, height: 100)) {
    PresetsListViewRow(location: try! Location(coordinate: CLLocationCoordinate2D(latitude: 40.4380638, longitude: -3.7495758)))
}
