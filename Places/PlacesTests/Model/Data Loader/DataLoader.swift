//
//  DataLoader.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

@testable import Places
import Foundation
import Testing

@Suite struct DataLoading {
    @Test("Loads and parses mock data")
    func loadsAndParsesMockData() async throws {
        struct MockNetworker: Networker {
            func data(from location: URL) async throws -> (Data, URLResponse) {
                return (LocationsResponse.testData, HTTPURLResponse(url: location, statusCode: 200, httpVersion: "1.1", headerFields: nil)!) // Force-unwrapping is safe because all values are known-good literals
            }
        }
        
        let load = DataLoader(networker: MockNetworker())
        
        #expect(try await load() == LocationsResponse.test.locations)
    }
    
    @Test("Throws appropriate error for unexpected response type")
    func throwsForUnexpectedResponseType() async throws {
        struct MockNetworker: Networker {
            func data(from location: URL) async throws -> (Data, URLResponse) {
                return (Data(), URLResponse())
            }
        }
        
        let load = DataLoader(networker: MockNetworker())
        
        await #expect(throws: DataLoader.Error.unexpectedProtocol) {
            try await load()
        }
    }
    
    @Test("Throws appropriate error for unsuccessful HTTP status", arguments: Array(100...103) + Array(300...308) + Array(400...418) + Array(421...426) + [428, 429, 431, 451] + Array(500...511))
    func throwsForUnsuccessfulHTTPStatus(_ status: Int) async throws {
        struct MockNetworker: Networker {
            
            let status: Int
            
            func data(from location: URL) async throws -> (Data, URLResponse) {
                return (Data(), HTTPURLResponse(url: location, statusCode: status, httpVersion: "1.1", headerFields: nil)!) // Force-unwrapping is safe because all values are known-good literals
            }
        }
        
        let load = DataLoader(networker: MockNetworker(status: status))
        
        await #expect(throws: DataLoader.Error.unsuccessfulStatusCode(status: status)) {
            try await load()
        }
    }
}
