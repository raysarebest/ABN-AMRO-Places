//
//  CLLocationCoordinate2DCodable.swift
//  PlacesTests
//
//  Created by Michael Hulet on 11/25/24.
//

@testable import Places
import CoreLocation
import Testing

extension CLLocationCoordinate2D {
    struct Codable {
        
        @Test("A round trip through both the encoder and decoder produces a result identical to the input", arguments: defaultArguments)
        func codingRoundTripProducesOriginalResult(coordinate: CLLocationCoordinate2D) async throws {
            let data = try JSONEncoder().encode(coordinate)
            let decoded = try JSONDecoder().decode(CLLocationCoordinate2D.self, from: data)
            
            #expect(decoded == coordinate)
        }
    }
}
