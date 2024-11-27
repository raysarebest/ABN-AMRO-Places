//
//  CLLocationCoordinate2DCustomTestStringConvertible.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

import CoreLocation
import Testing

extension CLLocationCoordinate2D: @retroactive CustomTestStringConvertible {
    public var testDescription: String {
        get {
            switch self {
                case kCLLocationCoordinate2DInvalid:
                    "Invalid"
                default:
                    "\(latitude), \(longitude)"
                }
        }
    }
}
