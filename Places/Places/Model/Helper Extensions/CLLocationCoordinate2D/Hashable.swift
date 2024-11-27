//
//  Hashable.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import CoreLocation

extension CLLocationCoordinate2D: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
