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
    
    var selectedLocation: CLLocationCoordinate2D? {
        get {
            guard let latitude = selectedLatitude, let longitude = selectedLongitude else {
                return nil
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            return if CLLocationCoordinate2DIsValid(coordinate) {
                coordinate
            }
            else {
                nil
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapReader { map in
                Map(position: $camera) {
                    if let location = selectedLocation {
                        Marker("custom.selection-pin.title", coordinate: location)
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
                
                if let location = selectedLocation {
                    Link("custom.open-wiki-button.title", destination: wikiLink(for: location))
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
        .onChange(of: selectedLocation) { _, newLocation in
            if let location = newLocation {
                withAnimation {
                    camera = .camera(MapCamera(centerCoordinate: location, distance: 10_000))
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
    
    private func wikiLink(for coordinate: CLLocationCoordinate2D) -> URL {
        let wikiURLComponents = NSURLComponents()
        wikiURLComponents.scheme = "wikipedia"
        wikiURLComponents.host = "places"
        
        wikiURLComponents.queryItems = [
            URLQueryItem(name: "latitude", value: String(coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(coordinate.longitude))
        ]
        
        return wikiURLComponents.url!
    }
}

#Preview {
    CustomLocationView()
}
