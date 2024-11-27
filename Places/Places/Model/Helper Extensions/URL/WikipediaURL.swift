//
//  WikipediaURL.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

import Foundation

extension URL {
    static func wikipediaURL(at location: Location) -> Self {
        let wikiURLComponents = NSURLComponents()
        wikiURLComponents.scheme = "wikipedia"
        wikiURLComponents.host = "places"
        
        wikiURLComponents.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude))
        ]
        
        if let name = location.name {
            wikiURLComponents.queryItems?.append(URLQueryItem(name: "name", value: name))
        }
        
        return wikiURLComponents.url! // Force-unwrapping is safe because we don't touch the path, which malforming is documented to be the only way to generate a nil URL
    }
}
