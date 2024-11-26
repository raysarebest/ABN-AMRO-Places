//
//  Equatable.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.latitude == right.latitude && left.longitude == right.longitude
    }
}
