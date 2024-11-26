//
//  CLLocationCoordinate2DHashable.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import CoreLocation
import Testing

extension CLLocationCoordinate2D {
    struct Hashable {
        @Test("Changing a property changes the whole instance's hash", arguments: defaultArguments)
        func changingValueChangesHash(coordinate: CLLocationCoordinate2D) {
            let baseHash = hash(for: coordinate)
            
            var mutableCoordinate = coordinate
            mutableCoordinate.latitude = .random(in: -90...90)
            
            let latitudeMutatedHash = hash(for: mutableCoordinate)
            
            #expect(baseHash != latitudeMutatedHash)
            
            mutableCoordinate.longitude = .random(in: -180...180)
            
            let longitudeMutatedHash = hash(for: mutableCoordinate)
            
            #expect(baseHash != longitudeMutatedHash)
            #expect(latitudeMutatedHash != longitudeMutatedHash)
        }
        
        @Test("Identical values have the same hash", arguments: defaultArguments)
        func identicalValuesHaveSameHash(coordinate: CLLocationCoordinate2D) {
            #expect(hash(for: coordinate) == hash(for: coordinate))
        }
        
        private func hash(for coordinate: CLLocationCoordinate2D) -> Int {
            var hasher = Hasher()
            hasher.combine(coordinate)
            return hasher.finalize()
        }
    }
}
