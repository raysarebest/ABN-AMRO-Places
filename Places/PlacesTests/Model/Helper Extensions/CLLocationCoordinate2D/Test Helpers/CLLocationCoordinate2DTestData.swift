//
//  CLLocationCoordinate2DTestData.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import CoreLocation

extension CLLocationCoordinate2D {
    static let abnAmroOffice = CLLocationCoordinate2DMake(52.337328, 4.8743264)
    
    static let defaultArguments = [CLLocationCoordinate2D(latitude: .random(in: -90...90), longitude: .random(in: -180...180)),
                                   .abnAmroOffice,
                                   kCLLocationCoordinate2DInvalid]
    
    static var random: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(Double.random(in: -90...90), Double.random(in: -180...180))
        }
    }
}
