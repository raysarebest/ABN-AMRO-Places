//
//  Codable.swift
//  Places
//
//  Created by Michael Hulet on 11/25/24.
//

import CoreLocation

extension CLLocationCoordinate2D: @retroactive Codable {
    
    public enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(latitude: try container.decode(CLLocationDegrees.self, forKey: .latitude),
                  longitude: try container.decode(CLLocationDegrees.self, forKey: .longitude))
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
