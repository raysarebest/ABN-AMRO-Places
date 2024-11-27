//
//  AccessibleLabeledContentStyle.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import SwiftUI

struct AccessibleLabeledContentStyle: LabeledContentStyle {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    func makeBody(configuration: Configuration) -> some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 8) {
                configuration.label
                configuration.content
            }
        }
        else {
            HStack {
                configuration.label
                configuration.content
            }
        }
    }
}

extension LabeledContentStyle where Self == AccessibleLabeledContentStyle {
    static var accessible: Self {
        get {
            return Self()
        }
    }
}
