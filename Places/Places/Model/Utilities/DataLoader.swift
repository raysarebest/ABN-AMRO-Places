//
//  DataLoader.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

import Foundation

class DataLoader {
    private let download: (URL) async throws -> (Data, URLResponse)
    private let decoder: JSONDecoder
    
    init(networker: some Networker, decoder: JSONDecoder = JSONDecoder()) {
        self.download = networker.data(from:)
        self.decoder = decoder
    }
    
    func callAsFunction() async throws -> [Location] {
        let presetURL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")! // Force-unwrapping is safe because it's instantiating with a known-good literal
        
        let (data, response) = try await download(presetURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.unexpectedProtocol
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw Error.unsuccessfulStatusCode(status: httpResponse.statusCode)
        }
        
        return try decoder.decode(LocationsResponse.self, from: data).locations
    }
    
    enum Error: Swift.Error, Equatable {
        case unexpectedProtocol
        case unsuccessfulStatusCode(status: Int)
    }
}
