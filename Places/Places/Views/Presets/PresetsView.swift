//
//  PresetsView.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import SwiftUI

struct PresetsView: View {
    
    @State private var locations: [Location]? = nil
    
    var body: some View {
        switch locations {
            case .none:
                ProgressView()
                    .task {
                        try! await reload()
                    }
            case .some(let locations):
                if locations.isEmpty {
                    ContentUnavailableView(unavailableTitle, systemImage: unavailableImage)
                }
                else {
                    List {
                        ForEach(Array(locations.lazy.enumerated()), id: \.offset) { _, location in
                            Link(destination: wikiURL(for: location)) {
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
                                    
                                    Text("presets.coordinate.format (latitude: \(location.coordinate.latitude), longitude:  \(location.coordinate.longitude))")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .refreshable {
                        try! await reload()
                    }
                    
                }
        }
    }
    
    func wikiURL(for location: Location) -> URL {
        
        let wikiURLComponents = NSURLComponents()
        wikiURLComponents.scheme = "wikipedia"
        wikiURLComponents.host = "places"
        
        wikiURLComponents.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude))
        ]
        
        if let name = location.name {
            wikiURLComponents.queryItems?.append(URLQueryItem(name: "name", value: name))
        }
        
        return wikiURLComponents.url!
    }
    
    func reload() async throws {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!)
        
        locations = try JSONDecoder().decode(LocationsResponse.self, from: data).locations
    }
    
    private var unavailableTitle: LocalizedStringKey {
        get {
            return "presets.not-available.title"
        }
    }
    
    private var unavailableImage: String {
        get {
            return "mappin.slash"
        }
    }
}

struct LocationsResponse: Codable {
    let locations: [Location]
}

#Preview {
    PresetsView()
}
