//
//  CoordinatePartEditor.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import SwiftUI
import CoreLocation

struct CoordinatePartEditor: View {
    let title: LocalizedStringKey
    @Binding private(set) var coordinatePart: CLLocationDegrees?
    
    init(title: LocalizedStringKey, coordinatePart: Binding<CLLocationDegrees?>) { // Manually writing initializer because auto-generated one erroneously accepts nil as a default value for coordinatePart
        self.title = title
        self._coordinatePart = coordinatePart
    }
    
    var body: some View {
        LabeledContent(title) {
            TextField(title, value: $coordinatePart.animation(), format: .number)
        }
        .accessibilityAddTraits(.isSearchField)
        .accessibilityAdjustableAction { direction in
            
            let interval: CLLocationDegrees = {
                let absoluteInterval: CLLocationDegrees = 0.05
                
                return switch direction {
                    case .increment: absoluteInterval
                    case .decrement: -absoluteInterval
                    @unknown default: 0
                }
            }()
            
            guard let part = Binding($coordinatePart) else {
                coordinatePart = interval
                return
            }
            
            part.wrappedValue += interval
        }
    }
}
