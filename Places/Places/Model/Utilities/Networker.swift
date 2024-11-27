//
//  Networker.swift
//  Places
//
//  Created by Michael Hulet on 11/26/24.
//

import Foundation

protocol Networker {
    func data(from: URL) async throws -> (Data, URLResponse)
}
