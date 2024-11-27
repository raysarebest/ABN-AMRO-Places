//
//  WikipediaURL.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

@testable import Places
import Foundation
import Testing


@Suite struct WikipediaURL {
    @Test("Wikipedia URL formed from Location produces accurate URL", arguments: try Location.defaultArguments)
    func wikipediaURLFromLocationIsValid(location: Location) {
        
        var expectedURL = URL(string: "wikipedia://places?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)")! // Force-unwrapping is safe because URL string is generated from known-good template with data that can't be malformed
        
        if let name = location.name {
            expectedURL.append(queryItems: [URLQueryItem(name: "name", value: name)])
        }
        
        #expect(expectedURL == .wikipediaURL(at: location))
    }
}
