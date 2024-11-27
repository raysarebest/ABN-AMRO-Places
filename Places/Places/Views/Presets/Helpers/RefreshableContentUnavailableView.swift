//
//  RefreshableContentUnavailableView.swift
//  Places
//
//  Created by Michael Hulet on 11/27/24.
//

import SwiftUI

struct RefreshableContentUnavailableView<Error: Swift.Error>: View {
    
    let title: LocalizedStringKey
    let symbolName: String
    let error: Error?
    
    @Environment(\.refresh) private var refresh
    @State private var refreshTask: Task<Void, Never>? = nil
    
    init(title: LocalizedStringKey, symbolName: String, error: Error) {
        self.title = title
        self.symbolName = symbolName
        self.error = error
    }
    
    var body: some View {
        VStack {
            ContentUnavailableView(title, systemImage: symbolName, description: errorDescription)
            
            if let refresh {
                Button("presets.unavailable.refresh-button.title") {
                    refreshTask = Task {
                        await refresh()
                    }
                }
            }
        }
        .onDisappear {
            refreshTask?.cancel()
        }
    }
    
    private var errorDescription: Text? {
        return if let error {
            Text(error.localizedDescription)
        }
        else {
            nil
        }
    }
}

extension RefreshableContentUnavailableView where Error == Never {
    init(title: LocalizedStringKey, symbolName: String) {
        self.title = title
        self.symbolName = symbolName
        self.error = nil
    }
}

#if DEBUG

enum DummyError: Error {
    case example
}

#Preview {
    RefreshableContentUnavailableView(title: "preview.title", symbolName: "exclamationmark.triangle.fill", error: DummyError.example)
}

#endif
