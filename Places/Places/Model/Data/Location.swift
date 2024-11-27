//
//  Location.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import CoreLocation

struct Location: Codable, Hashable {
    let name: String?
    let coordinate: CLLocationCoordinate2D
    
    init(name: String? = nil, coordinate: CLLocationCoordinate2D) throws(Error) {
        self.name = name
        
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            throw Error.invalid
        }
        
        self.coordinate = coordinate
    }
    
    // MARK: - Helper Types
    
    enum Error: Swift.Error {
        case invalid
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decodeIfPresent(String.self, forKey: .name)
        coordinate = CLLocationCoordinate2D(latitude: try container.decode(CLLocationDegrees.self, forKey: .latitude),
                                            longitude: try container.decode(CLLocationDegrees.self, forKey: .longitude))
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
