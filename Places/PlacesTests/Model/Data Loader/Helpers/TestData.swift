//
//  TestData.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

@testable import Places
import Foundation

private class BundleFinder {}

extension LocationsResponse {
    static let testData = try! Data(contentsOf: Bundle(for: BundleFinder.self).url(forResource: "test", withExtension: "json")!) // Force-unwrapping and force-trying is safe because the file is known to exist in the bundle and be well-formed
    static let test = try! JSONDecoder().decode(Self.self, from: testData)
}
