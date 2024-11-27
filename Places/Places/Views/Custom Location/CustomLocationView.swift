//
//  CustomLocationView.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import SwiftUI
import MapKit

struct CustomLocationView: View {
    
    @State private var camera = MapCameraPosition.automatic
    @State private var selectedLatitude: CLLocationDegrees? = nil
    @State private var selectedLongitude: CLLocationDegrees? = nil
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private var selectedLocation: Location? {
        get throws {
            guard let latitude = selectedLatitude, let longitude = selectedLongitude else {
                return nil
            }
            
            return try Location(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MapReader { map in
                Map(position: $camera) {
                    if let location = try? selectedLocation {
                        Marker(coordinate: location.coordinate) {
                            Text("custom.selection-pin.title")
                            Text("custom.selection-pin.coordinate.title (latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude))") // Not shown in the visual UI but read by the accessibility system to give more context than just the selection label
                        }
                        .mapItemDetailSelectionAccessory(nil)
                    }
                }
                .onTapGesture { position in
                    guard let selection = map.convert(position, from: .local) else {
                        return
                    }
                    
                    withAnimation {
                        selectedLatitude = selection.latitude
                        selectedLongitude = selection.longitude
                    }
                }
            }
            
            let paddingInset: CGFloat = 8
            
            VStack(spacing: paddingInset) {
                
                if let location = try? selectedLocation {
                    Link("custom.open-wiki-button.title", destination: .wikipediaURL(at: location))
                        .buttonStyle(.borderedProminent)
                }
                
                CoordinatePartEditor(title: latitudeEntryTitle, coordinatePart: $selectedLatitude)
                
                CoordinatePartEditor(title: longitudeEntryTitle, coordinatePart: $selectedLongitude)
            }
            .accessibilityAddTraits(.isSummaryElement)
            .labeledContentStyle(.accessible)
            .textFieldStyle(.roundedBorder)
            .padding(paddingInset)
            .labeledContentStyle(.automatic)
            .transition(.blurReplace)
        }
        .onChange(of: try? selectedLocation) { _, newLocation in
            if let location = newLocation {
                
                withAnimation(reduceMotion ? nil : .default) {
                    camera = .camera(MapCamera(centerCoordinate: location.coordinate, distance: 10_000))
                }
            }
        }
    }
    
    private var latitudeEntryTitle: LocalizedStringKey {
        get {
            return "custom.text-field.latitude.title"
        }
    }
    
    private var longitudeEntryTitle: LocalizedStringKey {
        get {
            return "custom.text-field.longitude.title"
        }
    }
}

#Preview {
    CustomLocationView()
}
