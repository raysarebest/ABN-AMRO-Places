//
//  Initializer.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

@testable import Places
import CoreLocation
import Testing

extension Location {
    struct Initializer {
        @Test("The initializer throws an error when the coordinate is invalid")
        func initializerThrowsWithInvalidCoordinate() {
            #expect(throws: Error.invalid) {
                try Location(name: "Invalid", coordinate: kCLLocationCoordinate2DInvalid)
            }
        }
    }
}
