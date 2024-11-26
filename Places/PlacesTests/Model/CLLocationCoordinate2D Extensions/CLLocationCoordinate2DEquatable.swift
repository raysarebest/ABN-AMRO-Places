//
//  CLLocationCoordinate2DEquatable.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import CoreLocation
import Testing

extension CLLocationCoordinate2D {
    struct Equatable {
        
        @Test("A coordinate is equal to itself", arguments: defaultArguments)
        func identity(location: CLLocationCoordinate2D) {
            #expect(location == location)
        }
        
        @Test("Coordinates with different values do not compare equally", arguments: zip(defaultArguments, defaultArguments.dropFirst() + [defaultArguments.first!])) // Shifts the first to the end so they'll be unequal. Force-unwrapping is ok because defaultArguments is statically known to have contents
        func different(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) {
            #expect(left != right)
        }
    }
}
