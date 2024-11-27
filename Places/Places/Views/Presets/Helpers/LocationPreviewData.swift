//
//  LocationPreviewData.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import UIKit

#if DEBUG

extension Array where Element == Location {
    static let preview = {
        let data = NSDataAsset(name: "locations")!.data // Force-unwrapping is safe because the data is guaranteed to exist in the preview asset catalog
        
        return try! JSONDecoder().decode(Self.self, from: data) // Force-trying is safe because the bundled data is known to be valid
    }()
}

#endif
