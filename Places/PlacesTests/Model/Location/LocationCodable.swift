//
//  LocationCodable.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

@testable import Places
import Foundation
import Testing

extension Location {
    struct Codable {
        @Test("A round trip through both the encoder and decoder produces a result identical to the input", arguments: try defaultArguments)
        func codingRoundTripProducesOriginalResult(location: Location) async throws {
            let data = try JSONEncoder().encode(location)
            let decoded = try JSONDecoder().decode(Location.self, from: data)
            
            #expect(decoded == location)
        }
    }
}
