//
//  LocationCustomTestStringConvertible.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

@testable import Places
import Testing

extension Location: @retroactive CustomTestStringConvertible {
    public var testDescription: String {
        get {
            return name ?? "Anonymous (\(coordinate.testDescription))"
        }
    }
}
