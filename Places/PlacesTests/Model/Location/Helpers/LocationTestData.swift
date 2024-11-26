//
//  LocationTestData.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

import CoreLocation
@testable import Places

extension Location {
    static var defaultArguments: [Self] {
        get throws {
            return try [Location(name: nil, coordinate: .random), Location(name: "ABN AMRO Office", coordinate: .abnAmroOffice)]
        }
    }
}
