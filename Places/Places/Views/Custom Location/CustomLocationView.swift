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
    
    private var selectedLocation: Location? {
        get throws {
            guard let latitude = selectedLatitude, let longitude = selectedLongitude else {
                return nil
            }
            
            return try Location(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapReader { map in
                Map(position: $camera) {
                    if let location = try? selectedLocation {
                        Marker("custom.selection-pin.title", coordinate: location.coordinate)
                    }
                }
                .gesture(
                    LongPressGesture()
                        .sequenced(before: DragGesture(minimumDistance: 0).onEnded { drag in
                            if let selection = map.convert(drag.startLocation, from: .local) {
                                selectedLatitude = selection.latitude
                                selectedLongitude = selection.longitude
                            }
                        })
                )
            }
            
            VStack {
                
                if let location = try? selectedLocation {
                    Link("custom.open-wiki-button.title", destination: .wikipediaURL(at: location))
                        .buttonStyle(.borderedProminent)
                        .transition(.scale(1, anchor: .bottom))
                }
                
                LabeledContent(latitudeEntryTitle) {
                    TextField(latitudeEntryTitle, value: $selectedLatitude.animation(), format: .number)
                }
                
                LabeledContent(longitudeEntryTitle) {
                    TextField(longitudeEntryTitle, value: $selectedLongitude.animation(), format: .number)
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            .labeledContentStyle(.automatic)
            .background(.ultraThickMaterial)
        }
        .onChange(of: try? selectedLocation) { _, newLocation in
            if let location = newLocation {
                withAnimation {
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
